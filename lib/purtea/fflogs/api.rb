# frozen_string_literal: true

require 'oauth2'
require 'time'

module Purtea
  module FFLogs
    TOKEN_FILE = 'fflogs_token.json'
    EXPIRATION_THRESHOLD = 30

    # Contains methods to interact with the FF Logs API.
    class API
      def initialize(client_id, client_secret)
        @client_id = client_id
        @client_secret = client_secret
        @oa_client = OAuth2::Client.new(
          @client_id, @client_secret, site: BASE_URL
        )
        authorize!
      end

      def dump_schema
        GraphQL::Client.dump_schema(
          Purtea::FFLogs::HTTP,
          SCHEMA_FILE,
          context: { access_token: @token.token }
        )
      end

      def fights(code)
        result = CLIENT.query(
          GET_FIGHTS_QUERY,
          variables: { code: code },
          context: { access_token: @token.token }
        )

        report = result.data.report_data.report
        report.fights.map { |d| Fight.new d, report.start_time }
      end

      def authorize!
        load_token!
        return unless token_expired?

        refresh_token!
        save_token
      end

      def save_token
        return if @token.nil?

        Purtea.logger.debug 'Saving FF Logs API token to file'
        token_hash = @token.to_hash
        token_json = token_hash.to_json
        File.open(TOKEN_FILE, 'w') { |f| f.write token_json }
      end

      def load_token!
        return unless File.exist? TOKEN_FILE

        Purtea.logger.debug 'Loading FF Logs API token from file'
        token_hash = JSON.load_file TOKEN_FILE
        @token = OAuth2::AccessToken.from_hash(@oa_client, token_hash)
      end

      def refresh_token!
        # FF Logs does not issue refresh tokens
        Purtea.logger.debug 'Refreshing FF Logs API token'
        @token = @oa_client.client_credentials.get_token
      end

      def token_expired?
        return true if @token.nil?

        expires_at = Time.at(@token.expires_at)
        time_until_expire = expires_at - Time.now
        time_until_expire < EXPIRATION_THRESHOLD
      end
    end
  end
end

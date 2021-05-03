# frozen_string_literal: true

require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'fileutils'

module Purtea
  # Interacts with the Google Sheets API.
  class SheetApi
    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
    APP_NAME = 'Purtea'
    CREDENTIALS_PATH = 'google_credentials.json'
    TOKEN_PATH = 'google_token.yaml'
    SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS

    attr_reader :spreadsheet_id, :service

    def initialize(spreadsheet_id)
      @service = Google::Apis::SheetsV4::SheetsService.new
      @service.client_options.application_name = APP_NAME
      @service.authorization = authorize!
      @spreadsheet_id = spreadsheet_id
    end

    def append(range, data)
      vr = Google::Apis::SheetsV4::ValueRange.new values: data
      @service.append_spreadsheet_value(
        @spreadsheet_id,
        range,
        vr,
        insert_data_option: 'INSERT_ROWS',
        value_input_option: 'RAW'
      )
    end

    private

    def authorize!
      client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
      token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
      authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE,
                                                    token_store
      user_id = 'default'
      credentials = authorizer.get_credentials user_id

      if credentials.nil?
        url = authorizer.get_authorization_url base_url: OOB_URI
        code = prompt_code url
        credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: code, base_url: OOB_URI
        )
      end
      @credentials = credentials
    end

    def prompt_code(url)
      puts 'Open the following URL in the browser and enter the ' \
        "resulting code after authorization:\n#{url}"
      $stdin.gets
    end
  end
end

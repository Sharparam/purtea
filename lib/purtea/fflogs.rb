# frozen_string_literal: true

require 'graphql/client'
require 'graphql/client/http'

require 'purtea/fflogs/fight'
require 'purtea/fflogs/api'

module Purtea
  module FFLogs
    BASE_URL = 'https://www.fflogs.com'
    API_URL = "#{BASE_URL}/api/v2/client"
    SCHEMA_FILE = File.expand_path('../../fflogs_schema.json', __dir__)

    HTTP = GraphQL::Client::HTTP.new(API_URL) do
      def headers(context)
        unless (token = context[:access_token])
          raise 'Missing FF Logs access token'
        end

        {
          'Authorization' => "Bearer #{token}"
        }
      end
    end

    CLIENT = GraphQL::Client.new(
      schema: SCHEMA_FILE,
      execute: HTTP
    )

    GET_FIGHTS_QUERY = CLIENT.parse <<-GRAPHQL
      query($code: String) {
        reportData {
          report(code: $code) {
            startTime
            endTime
            fights {
              id
              encounterID
              gameZone {
                id
                name
              }
              name
              difficulty
              bossPercentage
              fightPercentage
              startTime
              endTime
              kill
            }
          }
        }
        rateLimitData {
          limitPerHour
          pointsResetIn
          pointsSpentThisHour
        }
      }
    GRAPHQL
  end
end

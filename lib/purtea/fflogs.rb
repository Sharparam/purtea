# frozen_string_literal: true

require 'graphql/client'
require 'graphql/client/http'

require 'purtea/fflogs/fight'

module Purtea
  module FFLogs
    BASE_URL = 'https://www.fflogs.com/api/v2/client'

    HTTP = GraphQL::Client::HTTP.new(BASE_URL) do
      def headers(context)
        unless token = context[:access_token]
          fail 'Missing FF Logs access token'
        end

        {
          'Authorization' => "Bearer #{token}"
        }
      end
    end

    CLIENT = GraphQL::Client.new(
      schema: 'fflogs_schema.json',
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

require 'purtea/fflogs/api'

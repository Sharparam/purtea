# frozen_string_literal: true

require 'time'

module Purtea
  module FFLogs
    class API
      def initialize(token)
        @token = token
      end

      def fights(code)
        result = CLIENT.query(
          GET_FIGHTS_QUERY,
          variables: { code: code },
          context: { access_token: @token }
        )

        report = result.data.report_data.report
        report.fights.map { |d| Fight.new d, report.start_time }
      end
    end
  end
end

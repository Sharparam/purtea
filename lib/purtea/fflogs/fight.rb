# frozen_string_literal: true

module Purtea
  module FFLogs
    # Describes a fight entry in FF Logs.
    class Fight
      ISO_FORMAT = '%Y-%m-%dT%H:%M:%S%:z'

      attr_reader :id, :encounter_id, :zone_id, :name, :zone_name, :difficulty,
                  :boss_percentage, :fight_percentage, :start_at, :end_at,
                  :duration, :last_phase_id

      # rubocop:disable Metrics/AbcSize
      def initialize(data, report_start_ms)
        @id = data.id
        @encounter_id = data.encounter_id
        @zone_id = data.game_zone.id
        @name = data.name
        @zone_name = data.game_zone.name
        @difficulty = data.difficulty
        @boss_percentage = data.boss_percentage
        @fight_percentage = data.fight_percentage
        @start_at = parse_fight_timestamp report_start_ms, data.start_time
        @end_at = parse_fight_timestamp report_start_ms, data.end_time
        @kill = data.kill
        @duration = parse_duration @start_at, @end_at
        @last_phase_id = data.last_phase
      end
      # rubocop:enable Metrics/AbcSize

      def kill?
        @kill
      end

      def to_s
        start_f = start_at.strftime(ISO_FORMAT)
        end_f = end_at.strftime(ISO_FORMAT)
        duration = Time.at(end_at - start_at).utc.strftime('%H:%M:%S')
        kw = kill? ? 'CLEAR' : 'WIPE'
        "[#{@id}] #{start_f} -> #{end_f} [#{duration}] " \
          "#{boss_percentage}% (#{fight_percentage}%) - #{kw}"
      end

      private

      def parse_fight_timestamp(report_start_ms, time)
        Time.at(0, report_start_ms + time, :millisecond)
      end

      def parse_duration(start_at, end_at)
        Time.at(end_at - start_at).utc
      end
    end
  end
end

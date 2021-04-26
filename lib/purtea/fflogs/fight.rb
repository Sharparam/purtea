# frozen_string_literal: true

module Purtea
  module FFLogs
    class Fight
      ISO_FORMAT = '%Y-%m-%dT%H:%S:%M%:z'

      attr_reader :id
      attr_reader :encounter_id
      attr_reader :zone_id
      attr_reader :name
      attr_reader :zone_name
      attr_reader :difficulty
      attr_reader :boss_percentage
      attr_reader :fight_percentage
      attr_reader :start_at
      attr_reader :end_at
      attr_reader :duration

      def initialize(data, report_start_ms)
        @id = data.id
        @encounter_id = data.encounter_id
        @zone_id = data.game_zone.id
        @name = data.name
        @zone_name = data.game_zone.name
        @difficulty = data.difficulty
        @boss_percentage = data.boss_percentage
        @fight_percentage = data.fight_percentage
        @start_at = Time.at(0, report_start_ms + data.start_time, :millisecond)
        @end_at = Time.at(0, report_start_ms + data.end_time, :millisecond)
        @kill = data.kill
        @duration = Time.at(@end_at - @start_at).utc
      end

      def kill? = @kill

      def to_s
        start_f = start_at.strftime(ISO_FORMAT)
        end_f = end_at.strftime(ISO_FORMAT)
        duration = Time.at(end_at - start_at).utc.strftime('%H:%M:%S')
        kw = kill? ? 'CLEAR' : 'WIPE'
        "[#{@id}] #{start_f} -> #{end_f} [#{duration}] #{boss_percentage}% (#{fight_percentage}%) - #{kw}"
      end
    end
  end
end

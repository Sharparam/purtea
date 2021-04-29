# frozen_string_literal: true

require 'gli'

TEA_ZONE_ID = 887

def format_percentage(percentage)
  if percentage.nil?
    'N/A'
  else
    format('%.2f%%', percentage)
  end
end

def float_comp(first, second)
  (first - second).abs < Float::EPSILON
end

def calc_end_phase(fight) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  return '???' unless fight.zone_id == TEA_ZONE_ID

  return 'N/A' if fight.boss_percentage.nil? || fight.fight_percentage.nil?

  if fight.boss_percentage.zero? && fight.fight_percentage >= 80.0
    return 'Living Liquid (LL)'
  end

  if fight.boss_percentage.positive? && fight.fight_percentage >= 75.0
    return 'Living Liquid (LL)'
  end

  if fight.boss_percentage.zero? && float_comp(fight.fight_percentage, 75.0)
    return 'Limit Cut (LC)'
  end

  '???'
end

def parse_fight(fight) # rubocop:disable Metrics/AbcSize
  [
    fight.id,
    fight.encounter_id,
    fight.zone_id,
    fight.zone_name,
    fight.name,
    fight.difficulty,
    format_percentage(fight.boss_percentage),
    format_percentage(fight.fight_percentage),
    fight.start_at.strftime(Purtea::FFLogs::Fight::ISO_FORMAT),
    fight.end_at.strftime(Purtea::FFLogs::Fight::ISO_FORMAT),
    fight.duration.strftime('%H:%M:%S'),
    calc_end_phase(fight),
    fight.kill? ? 'Y' : 'N'
  ]
end

module Purtea
  # Defines the CLI interface for Purtea.
  class CLI
    extend GLI::App

    program_desc 'FF Logs TEA stats import tool'
    program_long_desc <<~LONGDESC
      This tool helps you import TEA stats from FF Logs and writing it to a
      Google Sheet.
    LONGDESC
    version Purtea::VERSION

    subcommand_option_handling :normal
    arguments :strict

    desc 'Be verbose'
    switch %i[v verbose]

    pre do |global_options, _options, _args|
      if global_options[:verbose]
        Purtea.logger.debug!
      else
        Purtea.logger.info!
      end
    end

    desc 'Import FF Logs report to Google Sheet'
    long_desc <<~LONGDESC
      report_code should be the code for a report containing TEA fights on
      FF Logs.

      The tool will read the fight stats and import it as a table into the
      configured Google Sheet (at the configured range).
    LONGDESC
    arg :report_code
    command :import do |c|
      c.action do |_, _, args|
        code = args.shift
        config = Purtea::Config.load
        fflogs_api = Purtea::FFLogs::API.new(
          config['fflogs']['client_id'],
          config['fflogs']['client_secret']
        )
        fights = fflogs_api.fights(code)

        spreadsheet_data = fights.map { |f| parse_fight(f) }

        sheet = Purtea::SheetApi.new(config['sheet']['id'])
        sheet.append(config['sheet']['range'], spreadsheet_data)
      end
    end

    desc 'Tests the logging system'
    command :testlog do |c|
      c.action do
        l = Purtea.logger
        l.debug('This is a debug log')
        l.info('This is an info log')
        l.warn('This is a warn log')
        l.error('This is an error log')
        l.fatal('This is a fatal log')
        l.unknown('This is an unknown log')
      end
    end
  end
end

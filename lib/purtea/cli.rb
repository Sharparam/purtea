# frozen_string_literal: true

require 'thor'

def format_percentage(percentage)
  if percentage.nil?
    'N/A'
  else
    format('%.2f%%', percentage)
  end
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
    '', # End phase
    fight.kill? ? 'Y' : 'N'
  ]
end

module Purtea
  # Defines the CLI interface for Purtea.
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    class_option :verbose,
                 type: :boolean,
                 desc: 'Enable verbose output',
                 default: false,
                 aliases: %w[-v]

    map '-V' => 'version'
    map '--version' => 'version'

    desc 'version', 'prints version information and exits'
    def version
      puts Purtea::VERSION
    end

    desc 'import CODE', 'imports the given FF Logs report to the Google Sheet'
    def import(code)
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

    desc 'log_test', 'Tests the logging system'
    def log_test
      l = Purtea.logger
      if options[:verbose]
        l.debug!
      else
        l.info!
      end
      l.debug('This is a debug log')
      l.info('This is an info log')
      l.warn('This is a warn log')
      l.error('This is an error log')
      l.fatal('This is a fatal log')
      l.unknown('This is an unknown log')
    end
  end
end

# frozen_string_literal: true

require 'gli'

UWU_ZONE_ID = 777
TEA_ZONE_ID = 887

VALID_ZONE_IDS = [
  UWU_ZONE_ID,
  TEA_ZONE_ID
].freeze

TEA_PHASES = {
  1 => 'Living Liquid (LL)',
  2 => 'Limit Cut (LC)',
  3 => 'Brute Justice / Cruise Chaser (BJ/CC)',
  4 => 'Alexander Prime (AP)', # Temporal Stasis intermission phase on FFLogs
  5 => 'Alexander Prime (AP)',
  6 => 'Perfect Alexander (PA)'
}.freeze

UWU_PHASES = {
  1 => 'Garuda',
  2 => 'Ifrit',
  3 => 'Titan',
  4 => 'LBs' # FFLogs calls this "Magitek Bits"
}.freeze

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

def calc_uwu_phase(fight)
  return UWU_PHASES[fight.last_phase_id] if UWU_PHASES.key? fight.last_phase_id

  # If we reach here, we have gotten into what FFLogs collectively refers to
  # as the "The Ultima Weapon" phase. FFLogs doesn't divide this up into the
  # individual sub-phases of Predation, Annihilation, et.c. so we have to do
  # our own logic.

  if float_comp(fight.fight_percentage, 50.0) &&
     (fight.boss_percentage.zero? || float_comp(fight.boss_percentage, 100.0))
    return 'LBs'
  end

  return 'Predation???' if fight.fight_percentage > 39.5

  return 'Annihilation???' if fight.boss_percentage >= 49.95

  'Suppression???'
end

def calc_tea_phase(fight)
  TEA_PHASES[fight.last_phase_id] || '???'
end

def calc_end_phase(fight)
  return 'N/A' if fight.boss_percentage.nil? || fight.fight_percentage.nil?

  return calc_uwu_phase(fight) if fight.zone_id == UWU_ZONE_ID

  return calc_tea_phase(fight) if fight.zone_id == TEA_ZONE_ID

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
        fights = fflogs_api.fights(code).select do |f|
          VALID_ZONE_IDS.include? f.zone_id
        end

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

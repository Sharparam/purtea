# frozen_string_literal: true

module Purtea # rubocop:disable Style/Documentation
  class << self
    attr_writer :logger

    def logger
      @logger ||= Logger.new($stdout).tap do |log|
        log.progname = name
      end
    end
  end
end

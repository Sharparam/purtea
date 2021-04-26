# frozen_string_literal: true

require 'dotenv/load'
require 'tomlrb'

module Purtea
  # Contains methods to load the Purtea config.
  module Config
    DEFAULT_CONFIG_PATH = 'config.toml'
    DEFAULT_ENV_PREFIX = 'PURTEA_'
    ENV_NESTED_SEPARATOR = '__'

    class << self
      def load(path = DEFAULT_CONFIG_PATH, env_prefix: DEFAULT_ENV_PREFIX)
        config = if File.exist? path
                   Tomlrb.load_file path
                 else
                   {}
                 end

        ENV.select { |k, _| k.start_with? env_prefix }.each do |key, value|
          key_path = key
                     .delete_prefix(env_prefix)
                     .split(ENV_NESTED_SEPARATOR)
                     .map(&:downcase)
          set_hash_by_path config, key_path, value unless key_path.empty?
        end

        config
      end

      private

      def set_hash_by_path(hash, key_path, value)
        if key_path.size == 1
          hash[key_path[0]] = value
          return
        end

        key = key_path.shift

        if hash[key].nil?
          hash[key] = {}
        elsif !hash[key].is_a? Hash
          raise ArgumentError, 'Specified key path contains a value'
        end

        set_hash_by_path hash[key], key_path, value
      end
    end
  end
end

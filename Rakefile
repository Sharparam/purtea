# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'purtea'
require 'dotenv/tasks'

config = Purtea::Config.load

namespace :fflogs do
  desc "Generates the schema for FF Logs' API into a default JSON file"
  task :gen_schema do
    client_id = config['fflogs']['client_id']
    client_secret = config['fflogs']['client_secret']
    api = Purtea::FFLogs::API.new client_id, client_secret
    api.dump_schema
  end
end

require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: %i[rubocop]

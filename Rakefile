# frozen_string_literal: true

require 'purtea'
require 'dotenv/tasks'

config = Purtea::Config.load

desc 'Purtea tasks'

namespace :fflogs do
  task :gen_schema do
    client_id = config['fflogs']['client_id']
    client_secret = config['fflogs']['client_secret']
    api = Purtea::FFLogs::API.new client_id, client_secret
    api.dump_schema
  end
end

# frozen_string_literal: true

require 'purtea'
require 'dotenv/tasks'

config = Purtea::Config.load

TOKEN = config['fflogs']['access_token']

desc 'Purtea tasks'

namespace :fflogs do
  task :gen_schema do
    GraphQL::Client.dump_schema(
      Purtea::FFLogs::HTTP,
      'fflogs_schema.json',
      context: { access_token: TOKEN }
    )
  end
end

require 'purtea'
require 'yaml'

config = YAML.load_file('config.yml')

desc "Print reminder about eating more fruit."

task :apple do
  puts "Eat more apples!"
end

namespace :fflogs do
  task :gen_schema do
    TOKEN = config['fflogs']['access_token']
    GraphQL::Client.dump_schema(
      Purtea::FFLogs::HTTP,
      'fflogs_schema.json',
      context: { access_token: TOKEN }
    )
  end
end

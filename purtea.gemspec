# frozen_string_literal: true

require_relative 'lib/purtea/version'

Gem::Specification.new do |s|
  s.name = 'purtea'
  s.version = Purtea::VERSION

  s.authors = [
    'Adam Hellberg (Sharparam)'
  ]

  s.email = [
    'sharparam@sharparam.com'
  ]

  s.summary = 'Imports TEA fights from FF Logs to Google Sheets'
  # s.description = 'TODO: Add description'
  s.homepage = 'https://github.com/Sharparam/purtea'
  s.license = 'MPL-2.0'
  s.required_ruby_version = Gem::Requirement.new('>= 3.0.0')

  s.metadata['homepage_uri'] = s.homepage
  s.metadata['source_code_uri'] = 'https://github.com/Sharparam/purtea'
  s.metadata['bug_tracker_uri'] = 'https://github.com/Sharparam/purtea/issues'

  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{\A(?:test|spec|features)/})
    end
  end

  s.bindir = 'exe'
  s.executables = s.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'dotenv', '~> 2.7'
  s.add_runtime_dependency 'google-api-client', '~> 0.53.0'
  s.add_runtime_dependency 'graphql-client', '~> 0.16.0'
  s.add_runtime_dependency 'oauth2', '~> 1.4'
  s.add_runtime_dependency 'tomlrb', '~> 2.0'

  s.add_development_dependency 'pry', '~> 0.14.1'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rspec', '~> 3.10'
  s.add_development_dependency 'rubocop', '~> 1.13'
  s.add_development_dependency 'rubocop-rspec', '~> 2.2'
  s.add_development_dependency 'solargraph', '~> 0.40.4'
end

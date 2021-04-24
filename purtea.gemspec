# frozen_string_literal: true

require File.expand_path('lib/purtea/version', __dir__)

Gem::Specification.new do |s|
  s.name = 'purtea'
  s.version = Purtea::VERSION

  s.required_ruby_version = '>= 3.0.0'

  s.authors = [
    'Adam Hellberg (Sharparam)'
  ]

  s.email = [
    'sharparam@sharparam.com'
  ]

  s.summary = 'Imports TEA fights from FF Logs to Google Sheets'

  s.homepage = 'https://github.com/Sharparam/purtea'
  s.licenses = ['MPL-2.0']

  s.executables << 'purtea'
  s.require_paths = ['lib']
  s.files = `git ls-files bin lib *.md LICENSE`.split("\n")

  s.add_runtime_dependency 'graphql-client', '~> 0.16.0'
  s.add_runtime_dependency 'google-api-client', '~> 0.53.0'

  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rubocop', '~> 1.13'
  s.add_development_dependency 'pry', '~> 0.14.1'

  s.metadata['source_code_uri'] = 'https://github.com/Sharparam/purtea'
  s.metadata['bug_tracker_uri'] = 'https://github.com/Sharparam/purtea/issues'
end

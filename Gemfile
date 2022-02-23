# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem "octokit", "~> 4.0"

group :development, :test do
  gem 'rspec'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'sawyer'

  # Simplecov to generate coverage info
  gem 'simplecov', require: false

  # Simplecov-cobertura to generate an xml coverage file which can then be uploaded to Codecov
  gem 'simplecov-cobertura'

  # For API calls
  gem 'json'
  gem 'rest-client'
end

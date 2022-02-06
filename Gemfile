# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'octokit'

group :development, :test do
  gem 'rspec'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'sawyer'
end

group :test do
  gem 'codecov', require: false
end

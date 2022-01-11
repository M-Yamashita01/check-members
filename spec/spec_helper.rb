# frozen_string_literal: true

require 'rspec'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'check_members_action'
require 'config_validator'
require 'github_organization'
require 'hcl2hash_conversion'
require 'terraform_reader'

require 'simplecov'
SimpleCov.start

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov

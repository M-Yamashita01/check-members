# frozen_string_literal: true

require 'rspec'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'terraform_reader'
require 'config_validator'
require 'github_organization'
require 'organization_seats_checker'

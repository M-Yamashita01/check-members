# frozen_string_literal: true

require 'rspec'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'check_members_action'
require 'config_validator'
require 'github_organization'
require 'hcl2json_conversion'
require 'terraform_reader'

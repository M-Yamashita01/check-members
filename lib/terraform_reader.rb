# frozen_string_literal: true

require 'json'
require_relative 'logging'
require_relative 'hcl2hash_conversion'

class TerraformReader
  include Logging

  private_class_method :new

  GITHUB_USER_RESOURCE_NAMES = [
    'github_membership',
    'github_repository_collaborator'
  ].freeze

  def self.open_file(terraform_json_file_path:)
    json_file = File.open(terraform_json_file_path)
    terraform_json = JSON.load(json_file)

    new(terraform_json: terraform_json)
  end

  def read_members
    begin
      planned_values = @terraform_json["planned_values"]
      root_module = planned_values["root_module"]
      resources = root_module["resources"]

      usernames = []
      resources.each do |resource|
        values = resource["values"]
        usernames << values["username"]
      end
    rescue => error
      logger.error(error.message)
      logger.error(error.backtrace.join("\n"))
      raise StandardError.new("The terraform json file is invalid.")
    end

    usernames.uniq
  end

  private

  def initialize(terraform_json:)
    @terraform_json = terraform_json
  end

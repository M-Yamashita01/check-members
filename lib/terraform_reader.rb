# frozen_string_literal: true

require 'json'
require_relative 'logging'

class TerraformReader
  include Logging

  private_class_method :new

  GITHUB_USER_RESOURCE_NAMES = [
    'github_membership',
    'github_repository_collaborator'
  ].freeze

  def self.open_file(terraform_json_file_path:)
    json_file = File.read(terraform_json_file_path)
    terraform_json = JSON.parse(json_file)

    new(terraform_json: terraform_json)
  end

  def read_members
    begin
      planned_values = @terraform_json['planned_values']
      root_module = planned_values['root_module']
      resources = root_module['resources']

      usernames = []
      resources.each do |resource|
        values = resource['values']
        usernames << values['username']
      end
    rescue StandardError => e
      logger.error(e.message)
      logger.error(e.backtrace.join("\n"))
      raise StandardError, 'The terraform json file is invalid.'
    end

    usernames.uniq
  end

  private

  def initialize(terraform_json:)
    @terraform_json = terraform_json
  end
end

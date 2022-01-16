# frozen_string_literal: true

require_relative 'logging'
require_relative 'hcl2hash_conversion'

class TerraformReader
  include Logging

  GITHUB_USER_RESOURCE_NAMES = [
    'github_membership',
    'github_repository_collaborator'
  ].freeze

  def initialize(terraform_directory_path:)
    read_members(terraform_directory_path: terraform_directory_path)
  end

  def read_members(terraform_directory_path:)
    @resource_configuration_blocks = []
    terraform_file_paths = terraform_file_paths(terraform_directory_path: terraform_directory_path)

    terraform_file_paths.each do |terraform_file_path|
      file_path = "#{terraform_directory_path}/#{terraform_file_path}"
      @resource_configuration_blocks << Hcl2hashConversion.convert_to_hash(terraform_file_path: file_path)
    end
  end

  def usernames
    return [] if @resource_configuration_blocks.nil?

    usernames = GITHUB_USER_RESOURCE_NAMES.collect do |github_user_resource|
      @resource_configuration_blocks.collect do |hashed_terraform|
        next if hashed_terraform['resource'].nil?

        resource = hashed_terraform['resource'][github_user_resource]
        next if resource.nil?

        github_usernames(resource_names: resource)
      end
    end

    usernames.flatten!.compact!.uniq!
  end

  private

  def terraform_file_paths(terraform_directory_path:)
    terraform_files_pattern = File.join('**', '*.tf')
    Dir.glob(terraform_files_pattern, base: terraform_directory_path)
  end

  def github_usernames(resource_names:)
    resource_names.filter_map do |resource_name, arguments|
      argument = arguments.first
      if argument.empty? || argument['username'].nil?
        logger.error("#{resource_name} does not have username.")
        next
      end

      argument['username']
    end
  end
end

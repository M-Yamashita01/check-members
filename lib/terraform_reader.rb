# frozen_string_literal: true

require_relative 'logging'
require_relative 'hcl2hash_conversion'
require_relative 'organization_member'

class TerraformReader
  include Logging

  def initialize(terraform_directory_path:)
    @terraform_directory_path = terraform_directory_path
  end

  def read_members
    github_membership_usernames = []
    github_repository_collaborator_usernames = []

    terraform_file_paths.each do |terraform_file_path|
      file_path = "#{@terraform_directory_path}/#{terraform_file_path}"
      hashed_terraform = Hcl2hashConversion.convert_to_hash(terraform_file_path: file_path)
      next if hashed_terraform['resource'].nil?

      resource = hashed_terraform['resource']
      if resource['github_membership']
        github_membership_usernames += github_usernames(resource_names: resource['github_membership'])
      elsif resource['github_repository_collaborator']
        github_repository_collaborator_usernames += github_usernames(resource_names: resource['github_repository_collaborator'])
      end
    end

    OrganizationMembers.new(
      membership_usernames: github_membership_usernames.uniq,
      repository_collaborator_usernames: github_repository_collaborator_usernames.uniq
    )
  end

  private

  def terraform_file_paths
    terraform_files_pattern = File.join('**', '*.tf')
    Dir.glob(terraform_files_pattern, base: @terraform_directory_path)
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

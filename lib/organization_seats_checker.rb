# frozen_string_literal: true

require 'logger'
require_relative 'config_validator'
require_relative 'github_organization'
require_relative 'terraform_reader'
require_relative 'organization_member'

class OrganizationSeatsChecker
  include Logging

  def initialize
    @access_token = ENV['GITHUB_PERSONAL_ACCESS_TOKEN']
    @membership_file_path = ENV['MEMBERSHIP_FILE_PATH']
    @repository_collaborator_file_path = ENV['REPOSITORY_COLLABORATOR_FILE_PATH']
  end

  def run
    config_validator =
      ConfigValidator.new(
        access_token: @access_token,
        membership_file_path: @membership_file_path,
        repository_collaborator_file_path: @repository_collaborator_file_path
      )
    unless config_validator.validate?
      logger.error('environment variable is invalid.')
      return
    end

    seats = github_organization_seats
    filled_seats = seats[:filled_seats]
    max_seats = seats[:max_seats]

    member_count = members_in_terraform

    puts "::set-output name=filled_seats::#{filled_seats}"
    puts "::set-output name=seats::#{max_seats}"
    puts "::set-output name=member_count::#{member_count}"
  rescue StandardError => e
    logger.error('This actions is finished with error.')
    logger.error(e.message)
    logger.error(e.backtrace.join("\n"))
  end

  private

  def github_organization_seats
    github_organization =
      GitHubOrganization.new(access_token: @access_token, organization_name: 'my-organization-sandbox')
    github_organization.seats
  end

  def members_in_terraform
    terraform_reader =
      TerraformReader.new(
        membership_file_path: @membership_file_path,
        repository_collaborator_file_path: @repository_collaborator_file_path
      )
    organization_members = terraform_reader.read_member
    organization_members.total_member_count
  end
end

# frozen_string_literal: true

require 'logger'
require_relative 'config_validator'
require_relative 'github_organization'
require_relative 'terraform_reader'
require_relative 'organization_member'

class CheckMembersAction
  include Logging

  def initialize
    @access_token = ENV['ACCESS_TOKEN']
    @membership_file_path = ENV['MEMBERSHIP_FILE_PATH']
    @repository_collaborator_file_path = ENV['REPOSITORY_COLLABORATOR_FILE_PATH']
    @organization_name = ENV['ORGANIZATION_NAME']
  end

  def run
    config_validator =
      ConfigValidator.new(
        access_token: @access_token,
        membership_file_path: @membership_file_path,
        repository_collaborator_file_path: @repository_collaborator_file_path,
        organization_name: @organization_name
      )
    unless config_validator.validate?
      logger.error('environment variable is invalid.')
      exit(false)
    end

    seats = github_organization_seats
    filled_seats = seats[:filled_seats]
    max_seats = seats[:max_seats]

    members_in_terraform = count_members_in_terraform

    puts "::set-output name=filled_seats::#{filled_seats}"
    puts "::set-output name=max_seats::#{max_seats}"
    puts "::set-output name=members_in_terraform::#{members_in_terraform}"

    exit
  rescue StandardError => e
    logger.error('This actions is finished with error.')
    logger.error(e.message)
    logger.error(e.backtrace.join("\n"))

    exit(false)
  end

  private

  def github_organization_seats
    github_organization =
      GitHubOrganization.new(access_token: @access_token, organization_name: @organization_name)
    github_organization.seats
  end

  def count_members_in_terraform
    terraform_reader =
      TerraformReader.new(
        membership_file_path: @membership_file_path,
        repository_collaborator_file_path: @repository_collaborator_file_path
      )
    organization_members = terraform_reader.read_member
    organization_members.total_members
  end
end

# frozen_string_literal: true

require 'logger'
require_relative 'config_validator'
require_relative 'github_api_request'
require_relative 'terraform_reader'

class CheckMembersAction
  include Logging

  def initialize
    @access_token = ENV['ACCESS_TOKEN']
    @terraform_directory_path = ENV['TERRAFORM_DIRECTORY_PATH']
    @organization_name = ENV['ORGANIZATION_NAME']
    @verify_account = ENV['INPUT_VERIFY_EXISTENCE_ACCOUNT']
  end

  def run
    config_validator =
      ConfigValidator.new(
        access_token: @access_token,
        terraform_directory_path: @terraform_directory_path,
        organization_name: @organization_name,
        verify_account: @verify_account
      )
    unless config_validator.validate?
      logger.error('environment variable is invalid.')
      exit(false)
    end

    seats = github_organization_seats
    filled_seats = seats[:filled_seats]
    max_seats = seats[:max_seats]

    members_in_terraform = usernames_in_terraform.size

    not_existed_usernames = []
    if @verify_account == 'true'
      not_existed_usernames = not_existed_usernames_in_github
      # if !sernames.empty?
      #   logger.error('Some users in terraform files do not exist.')
      #   logger.error("No exist users: #{usernames.join(',')}")
      #   exit(false)
      # end
    end

    puts "::set-output name=filled_seats::#{filled_seats}"
    puts "::set-output name=max_seats::#{max_seats}"
    puts "::set-output name=members_in_terraform::#{members_in_terraform}"
    puts "::set-output name=not_existed_usernames_in_github::#{not_existed_usernames}"

    exit
  rescue StandardError => e
    logger.error('This actions is finished with error.')
    logger.error(e.message)
    logger.error(e.backtrace.join("\n"))

    exit(false)
  end

  private

  def github_organization_seats
    github_api_request.seats(organization_name: @organization_name)
  end

  def exist_github_user?(username:)
    github_api_request.exist_user?(username: username)
  end

  def github_api_request
    @github_api_request ||= GithubApiRequest.new(access_token: @access_token)
  end

  def not_existed_usernames_in_github
    usernames_in_terraform.reject do |username|
      exist_github_user?(username: username)
    end
  end

  def usernames_in_terraform
    @terraform_reader ||=
      TerraformReader.new(terraform_directory_path: @terraform_directory_path)
    @terraform_reader.usernames
  end
end

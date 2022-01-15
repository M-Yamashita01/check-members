# frozen_string_literal: true

require_relative 'logging'

class ConfigValidator
  include Logging

  def initialize(access_token:, terraform_directory_path:, organization_name:, verify_account: nil)
    @access_token = access_token
    @terraform_directory_path = terraform_directory_path
    @organization_name = organization_name
    @verify_account = verify_account
  end

  def validate?
    if @access_token.nil? || @access_token.empty?
      logger.error('access token is empty.')
      return false
    end

    unless Dir.exist?(@terraform_directory_path)
      logger.error("Not such directory. terraform_directory_path: #{@terraform_directory_path}")
      return false
    end

    if @organization_name.nil? || @organization_name.empty?
      logger.error('organization name is empty.')
      return false
    end

    unless @verify_account.nil?
      if @verify_account != 'true' && @verify_account != 'false'
        logger.error('verify account should be set true or false.')
        return false
      end
    end

    true
  end
end

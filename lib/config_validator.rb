# frozen_string_literal: true

require_relative 'logging'

class ConfigValidator
  include Logging

  def initialize(access_token:, terraform_directory_path:, organization_name:)
    @access_token = access_token
    @terraform_directory_path = terraform_directory_path
    @organization_name = organization_name
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

    true
  end
end

# frozen_string_literal: true

require_relative 'logging'

class ConfigValidator
  include Logging

  def initialize(access_token:, membership_file_path:, repository_collaborator_file_path:)
    @access_token = access_token
    @membership_file_path = membership_file_path
    @repository_collaborator_file_path = repository_collaborator_file_path
  end

  def validate?
    if @access_token.nil? || @access_token.empty?
      logger.error('access token is empty.')
      return false
    end

    unless File.readable?(@membership_file_path)
      logger.error("membership file is not readable. membership file path: #{@membership_file_path}")
      return false
    end

    unless File.readable?(@repository_collaborator_file_path)
      logger.error("repository collaborator file is not readable.
        repository collaborator file path: #{@membership_file_path}")
      return false
    end

    true
  end
end

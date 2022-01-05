# frozen_string_literal: true

require 'open3'
require 'json'
require_relative 'logging'

class Hcl2hashConversion
  include Logging

  def self.convert_to_hash(terraform_file_path:)
    stdout_str, stderr_str, status = Open3.capture3("hcl2json #{terraform_file_path}")

    if !stderr_str.nil? && !stderr_str.empty?
      logger.error("Open3.capture3 stderr_str: #{stderr_str}")
      logger.error("Open3.capture3 status: #{status}")
      raise(stderr_str)
    end

    JSON.parse(stdout_str)
  end
end

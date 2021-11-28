# frozen_string_literal: true

require 'logger'

module Logging
  def logger
    @logger ||= Logger.new($stdout)
  end
end

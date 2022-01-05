# frozen_string_literal: true

require 'logger'

module Logging
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def logger
      @logger ||= Logger.new($stdout)
    end
  end

  def logger
    self.class.logger
  end
end

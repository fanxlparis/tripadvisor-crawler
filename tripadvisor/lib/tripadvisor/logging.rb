require 'rubygems'
require 'logger'

module Tripadvisor
  module Logging
    @@log = nil

    def log_config(level = Logger::WARN, out = STDOUT)
      @@log = Logger.new(out)
      @@log.level = level
      @@log
    end

    def log
      @@log = log_config if @@log.nil?
      @@log
    end

  end
end

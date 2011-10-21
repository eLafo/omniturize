require 'meta_vars'
require "omniturize/version"
require File.dirname(__FILE__) + '/omniturize/printer'
require File.dirname(__FILE__) + '/omniturize/base'
require 'cgi'

module Omniturize

  class << self
    def config(config_hash)
      config_hash.each do |key, val|
        module_eval do
          mattr_accessor key.to_sym
        end
        send("#{key}=", val)
      end
    end
  end
end

if defined?(Rails)
  require File.dirname(__FILE__) + '/omniturize_rails'
end

require "omniturize/version"
require File.dirname(__FILE__) + '/class_level_inheritable_attributes'
require File.dirname(__FILE__) + '/omniturize/printer'
require File.dirname(__FILE__) + '/omniturize/base'
require File.dirname(__FILE__) + '/omniturize/var'
require File.dirname(__FILE__) + '/omniturize/meta_js'
require File.dirname(__FILE__) + '/omniturize/meta_var'
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

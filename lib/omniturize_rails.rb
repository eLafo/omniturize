module Omniturize
  module ActionControllerMethods

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def omniturize(options = {})
        include InstanceMethods
        before_filter :set_reporter, options
        attr_accessor :reporter
      end
    end

    module InstanceMethods

      private

      def set_reporter(options = {})

        @reporter ||=  begin
          options[:controller].present? ? "#{options[:controller].classify}Reporter".constantize.new(self) :
                                          "#{self.controller_name.capitalize}Reporter".constantize.new(self)
        rescue NameError
          BasicReporter.new(self)
        end
      end

    end
  end
end

ActionController::Base.send(:include, Omniturize::ActionControllerMethods) if defined?(ActionController::Base)
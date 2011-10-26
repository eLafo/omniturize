module Omniturize
  module ActionControllerMethods

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def omniturize(options = {})
        include InstanceMethods
        before_filter{|c| c.send(:set_reporter, options.reverse_merge(:reporter => c.class.name.gsub(/Controller$/, '')))}
        attr_accessor :reporter
      end
    end

    module InstanceMethods

      private

      def set_reporter(options = {})
        @reporter ||=  begin
          "#{options[:reporter].classify.pluralize}Reporter".constantize.new(self)
        rescue NameError
          BasicReporter.new(self)
        end
      end

    end
  end
end

ActionController::Base.send(:include, Omniturize::ActionControllerMethods) if defined?(ActionController::Base)
# This code was proudly and shamelessly copied from
# http://railstips.org/blog/archives/2006/11/18/class-and-instance-variables-in-ruby/
# so let's all thank John Nunemaker with a loud and strong applause: PLAS!!!!'

module Omniturize
  module ClassLevelInheritableAttributes
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def inheritable_attributes(*args)
        @omniture_inheritable_attributes ||= [:omniture_inheritable_attributes]
        @omniture_inheritable_attributes += args
        args.each do |arg|
          class_eval %(
            class << self; attr_accessor :#{arg} end
          )
        end
        @omniture_inheritable_attributes
      end

      def inherited(subclass)
        @omniture_inheritable_attributes.each do |inheritable_attribute|
          instance_var = "@#{inheritable_attribute}"
          subclass.instance_variable_set(instance_var, instance_variable_get(instance_var))
        end
      end
    end
  end
end
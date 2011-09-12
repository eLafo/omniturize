module Omniturize
  class Base

    include Omniturize::ClassLevelInheritableAttributes
    include Omniturize::Printer
    inheritable_attributes :meta_vars, :meta_js_events, :meta_js_snippets
    
    attr_reader  :controller

    @meta_vars = []
    @meta_js_events = []
    @meta_js_snippets   = []


    class << self
      attr_accessor :meta_vars, :meta_js_events, :meta_js_snippets
      @@controller = nil

      def var(name, options={}, &block)
        meta_var = Omniturize::MetaVar.new(name.to_s, options)
        meta_var.add_var(block)
        meta_vars.insert(0, meta_var) unless meta_vars.include?(meta_var)
        meta_var
      end

      def event(options = {}, &block)
        meta_js(meta_js_events, block, options)
      end

      def js_snippet(options = {}, &block)
        meta_js(meta_js_snippets, block, options)
      end

      def find_meta_vars(name, action = nil)
        filter_collection_for_action(meta_vars.select{|x|x.matches_name?(name)}, action).uniq_by(:name)
      end

      def filter_collection_for_action(collection, action)
        return collection if action.blank?
        collection.select do |element|
          (element.only.present? && element.only.include?(action.try(:to_sym))) ||
          (element.except.present? && !element.except.include?(action.try(:to_sym))) ||
          (element.only.blank? && element.except.blank?)
        end
      end

      protected

      def meta_js(collection, block, options = {})
        meta_js = Omniture::MetaJs.new(options)
        meta_js.add_js(block)
        collection.insert(0, meta_js)
        meta_js
      end

    end

    def initialize(controller)
      @controller = controller
    end

    def vars(options = {})
      meta_collection_to_values(self.class.meta_vars.uniq_by(:name), options[:action])
    end
    
    def js_events(options = {})
      meta_collection_to_values(self.class.meta_js_events, options[:action]).uniq
    end

    def js_snippets(options = {})
      meta_collection_to_values(self.class.meta_js_snippets, options[:action]).uniq
    end

    def add_var(name, value)
      self.class.var(name) do
        value
      end
    end

    def find_var(name, options = {})
      vars(options[:action]).detect{|x|x.matches_name?(name)}
    end

    def meta_vars_to_vars(meta_vars)
      meta_vars.inject([]) do |vars, meta_var|
        vars << meta_var.value(controller) if meta_var
        vars
      end
    end

    protected

    def build_js_collection(procs_collection)
      procs_collection.inject([]) do |code, js|
        code << controller.instance_eval(&js)
        code
      end
    end

    def meta_collection_to_values(collection, action = nil)
      action.present? ? meta_vars_to_vars(self.class.filter_collection_for_action(collection, action)): meta_vars_to_vars(collection)
    end
  end
end

module Omniturize
  class Base

    include Omniturize::Printer
    include MetaVars

    has_meta_var :var, :default_namespace => 'default', :inheritable => true
    has_meta_var :event, :default_namespace => 'default', :inheritable => true
    has_meta_var :js_snippet, :default_namespace => 'default', :inheritable => true

    attr_reader  :controller

    class << self
      @@controller = nil
    end

    def initialize(controller)
      @controller = controller
    end
  end
end

module Omniturize
  class MetaVar

    DEFAULT_OPTIONS = { :delimiter => ',',
                        :unique => nil,
                        :expires_in => 0,
                        :only => [],
                        :except => []
    }

    attr_reader :name, :delimiter, :cache_key, :expires_in, :only, :except
    attr_accessor :value_procs

    def initialize(name, options = {})
      options = DEFAULT_OPTIONS.merge(options)
      @name = name
      @value_procs = []
      @delimiter = options[:delimiter]
      @cache_key = "omniture/#{name}/#{options[:unique]}"
      @expires_in = options[:expires_in]
      @only = Array(options[:only])
      @except = Array(options[:except])
    end

    def add_var(value_proc)
      value_procs << value_proc
    end

    # wrap up the value in a Var object and cache if needed
    def value(scope)
      if @expires_in > 0
        Rails.cache.fetch(@cache_key, :expires_in => @expires_in) do
          return_var(scope)
        end
      else
        return_var(scope)
      end
    end
    
    def return_var(scope)
      Var.new(name, value_procs.map{ |p| scope.instance_eval(&p) }.flatten.uniq.join(delimiter))
    end

    def matches_name?(name)
      select_condition = case name
        when Regexp then self.name.match(name)
        when String then self.name == name
        else raise ArgumentError.new('name must be a String or a Regexp')
      end
    end
    
  end
end

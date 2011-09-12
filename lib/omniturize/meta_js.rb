module Omniture
  class MetaJs
    attr_reader :cache_key, :expires_in, :only, :except, :delimiter
    attr_accessor :value_procs

    DEFAULT_OPTIONS = { :unique => nil,
                        :expires_in => 0,
                        :only => [],
                        :except => [],
                        :delimiter => ','
    }

    def initialize(options = {})
      options = DEFAULT_OPTIONS.merge(options)
      
      @value_procs = []
      @cache_key = "omniture/#{Time.now.to_i}/#{options[:unique]}"
      @expires_in = options[:expires_in]
      @only = options[:only]
      @except = options[:except]
    end

    def add_js(value_proc)
      value_procs << value_proc
    end

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
      value_procs.map{ |p| scope.instance_eval(&p) }.flatten.uniq.join(delimiter)
      #scope.instance_eval(&p)
    end
  end
end
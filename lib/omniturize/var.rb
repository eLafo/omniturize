module Omniturize
  class Var
    attr_reader :name, :value
    def initialize(name, value)
      if Omniturize::aliases && Omniturize::aliases[name.to_s]
        @name = Omniturize::aliases[name.to_s]
      else
        @name = name.to_s
      end
      @value = value
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

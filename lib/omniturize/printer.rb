module Omniturize
  module Printer

    def url(ssl = false)
      suite = Omniturize::suite.is_a?(Array) ? Omniturize::suite.join(',') : Omniturize::suite
      base_url =  ssl == :ssl ? Omniturize::ssl_url : Omniturize::base_url
      "#{base_url}/b/ss/#{suite}/#{Omniturize::version}/#{rand(9999999)}?#{query}"
    end
    
    def js(options = {})
      html_options = []
      options[:html_options].each_pair{|k,v| html_options << "#{k}=\"#{v}\""} if options[:html_options].present?
      output = <<-JS
        <script type="text/javascript" language="JavaScript" src="#{Omniturize::js_src}"></script>
        <script type="text/javascript" language="JavaScript" #{html_options.join(' ')}>
          #{js_vars(options)}
          #{print_js_events(options)}
          #{print_js_snippets(options)}
          var s_code=s.t();if(s_code)document.write(s_code)
        </script>
      JS
    end
    
    def query(options = {})
      vars(options).inject([]) do |query, var|
        query << var_to_query(var) if var.value && var.value != ""
        query
      end.join('&')
    end
    
    def js_vars(options = {})
      vars(options).inject([]) do |query, var|
        query << var_to_js(var) if var.value && var.value != ""
        query
      end.join(";\n") + ';'
    end
    
    def raw_vars(options = {})
      vars(options).inject([]) do |query, var|
        query << { var.name.to_sym => var.value } if var.value && var.value != ""
        query
      end
    end

    def print_js_events(options = {})
      values = js_events(options).join(',')
      values.blank? ? nil : "s.events=\"#{values}\""
    end

    def print_js_snippets(options = {})
      js_snippets(options).join("\n")
    end
    
    private

    def var_to_query(var)
      "#{ CGI::escape(var.name) }=#{ CGI::escape(var.value) }" if var
    end
    
    def var_to_js(var)
      %Q{\t#{Omniturize::var_prefix + '.' if Omniturize::var_prefix}#{var.name}="#{var.value}"} if var
    end
  end
end
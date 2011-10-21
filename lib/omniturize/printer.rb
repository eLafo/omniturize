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
          #{js_vars(options[:action])}
          #{print_js_events(options[:action])}
          #{print_js_snippets(options[:action])}
          var s_code=s.t();if(s_code)document.write(s_code)
        </script>
      JS
    end
    
    def query(options = {})
      vars(controller).inject([]) do |query, var|
        query << var_to_query(var) if var.value && var.value != ""
        query
      end.join('&')
    end
    
    def js_vars(action)
      output = (find_meta_vars(action) + find_meta_vars).uniq_by(&:name).map{|x| x.to_var(controller)}.inject([]) do |query, var|
        query << var_to_js(var) if var.value.present?
        query
      end.join(";\n")

      output.blank? ? nil : output + ';'
    end

    def raw_vars(options = {})
      vars(options).inject([]) do |query, var|
        query << { var.name.to_sym => var.value } if var.value && var.value != ""
        query
      end
    end

    def print_js_events(action)
      events = (find_meta_events(action) + find_meta_events).uniq_by(&:name).map{|event| event.to_var(controller)}.inject([]) do |values, event|
        (values << event.value) if event.value.present?
      end.join(',')
      events.blank? ? nil : "s.events=\"#{events}\";"
    end

    def print_js_snippets(action)
      (find_meta_js_snippets(action) + find_meta_js_snippets).uniq_by(&:name).map{|snippet| snippet.to_var(controller)}.inject([]) do |snippets, snippet|
        (snippets << snippet.value) if snippet.value.present?
      end.join("\n")
    end
    
    private

    def var_to_query(var)
      "#{ CGI::escape(var.name) }=#{ CGI::escape(var.value) }" if var
    end
    
    def var_to_js(var)
      %Q{\t#{Omniturize::var_prefix + '.' if Omniturize::var_prefix}#{var_name(var)}="#{var.value}"} if var
    end

    def var_name(var)
      Omniturize::aliases && Omniturize::aliases[var.name.to_s] ? Omniturize::aliases[var.name.to_s] : var.name
    end
  end
end
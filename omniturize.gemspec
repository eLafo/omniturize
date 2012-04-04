# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omniturize/version"

Gem::Specification.new do |s|
  s.name        = "omniturize"
  s.version     = Omniturize::VERSION
  s.authors     = ["eLafo"]
  s.email       = ["javierlafora@gmail.com"]
  s.homepage    = "https://github.com/eLafo/omniturize"
  s.summary     = %q{This gem integrates Omniture SiteCatalyst into your web app}
  s.description = %q{This gem integrates Omniture SiteCatalyst into your web app. You can specify vars, events and custom javascript for every action of a controller. This gem is proudly based on the omniture_client gem, from which it takes much code and ideas}

  s.rubyforge_project = "omniturize"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.requirements << 'meta_vars 1.0.2'
  s.add_dependency('meta_vars', '1.0.2')
end

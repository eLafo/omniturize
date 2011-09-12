# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omniturize/version"

Gem::Specification.new do |s|
  s.name        = "omniturize"
  s.version     = Omniturize::VERSION
  s.authors     = ["eLafo"]
  s.email       = ["javierlafora@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Gem for integrating omniture into your rails app}
  s.description = %q{Gem for integrating omniture into your rails app}

  s.rubyforge_project = "omniturize"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

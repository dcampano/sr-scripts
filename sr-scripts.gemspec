# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sr-scripts/version"

Gem::Specification.new do |s|
  s.name        = "sr-scripts"
  s.version     = Sr::Scripts::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Davy Campano"]
  s.email       = ["dcampano@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Admin scripts}
  s.description = %q{Admin scripts}

  s.rubyforge_project = "sr-scripts"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('fog')

end

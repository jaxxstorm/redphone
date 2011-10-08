# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "redphone/version"

Gem::Specification.new do |s|
  s.name        = "redphone"
  s.version     = Redphone::VERSION
  s.authors     = ["Sean Porter"]
  s.email       = ["portertech@gmail.com"]
  s.homepage    = "https://github.com/portertech/redphone"
  s.summary     = %q{A rubygem for talking to monitoring service APIs}
  s.description = %q{A rubygem for talking to monitoring service APIs}

  s.rubyforge_project = "redphone"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "json"
  s.add_development_dependency "rake"
  s.add_development_dependency "minitest"
end

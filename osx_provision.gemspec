# -*- encoding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/lib/osx_provision/version')

Gem::Specification.new do |spec|
  spec.name          = "osx_provision"
  spec.summary       = %q{Library for building Mac OSX provisioning}
  spec.description   = %q{Library for building Mac OSX computer provisioning}
  spec.email         = "alexander.shvets@gmail.com"
  spec.authors       = ["Alexander Shvets"]
  spec.homepage      = "http://github.com/shvets/osx_provision"

  spec.files         = `git ls-files`.split($\)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.version       = OsxProvision::VERSION


  
  spec.add_runtime_dependency "text-interpolator", ["~> 1.1"]
  spec.add_runtime_dependency "script_executor", ["~> 1.5"]
  spec.add_runtime_dependency "thor", ["~> 0.19"]
  spec.add_runtime_dependency "json_pure", ["~> 1.8"]
  spec.add_development_dependency "gemspec_deps_gen", ["~> 1.1"]
  spec.add_development_dependency "gemcutter", ["~> 0.7"]

end


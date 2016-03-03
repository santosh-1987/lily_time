# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lily_time/version'

Gem::Specification.new do |spec|
  spec.name          = "lily_time"
  spec.version       = LilyTime::VERSION
  spec.authors       = ["Santosh Kumar Mohanty"]
  spec.email         = ["santoshkumar.mohanty@timeinc.com"]

  spec.summary       = %q{Lily Repo Wrapper}
  spec.description   = %q{Lily Repository wrapper for REST & Advanced tools , Lily is a Schema based NOSQL DB which communicates with HBASE for Storing data's in user Specified Format.}
  spec.homepage      = "https://github."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end

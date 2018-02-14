
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "xsay/version"

Gem::Specification.new do |spec|
  spec.name          = "xsay"
  spec.version       = Xsay::VERSION
  spec.authors       = ["mokha"]
  spec.email         = ["mokha@cisco.com"]

  spec.summary       = %q{xsay, like cowsay but much more fun..}
  spec.description   = %q{xsay, like cowsay but much more fun..}
  spec.homepage      = "http://www.mokhan.ca/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 0.20"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name = "ruby-maybe"
  s.version = "0.0.2"
  s.platform = Gem::Platform::RUBY
  s.authors = ["Callum Stott"]
  s.email = ["callum.stott@me.com"]
  s.summary = "Maybe monad implementation for Ruby"

  s.require_paths = ['lib']
  s.files = `git ls-files`.split("\n")
end

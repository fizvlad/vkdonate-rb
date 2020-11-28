# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vkdonate'

Gem::Specification.new do |spec|
  spec.name          = 'vkdonate'
  spec.version       = Vkdonate::VERSION
  spec.authors       = ['Fizvlad']
  spec.email         = ['fizvlad@mail.ru']

  spec.summary       = 'This is small non-official gem which provides interface to interact with vkdonate.ru API'
  spec.homepage      = 'https://github.com/fizvlad/vkdonate-rb'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>=2.7.1'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/fizvlad/vkdonate-rb'
  spec.metadata['changelog_uri'] = 'https://github.com/fizvlad/vkdonate-rb/releases'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  spec.add_runtime_dependency('json', '~> 2.3')
end

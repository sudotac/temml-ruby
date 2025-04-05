# frozen_string_literal: true

# SPDX-License-Identifier: CC0-1.0 AND MIT

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'temml/version'

Gem::Specification.new do |s|
  s.name = 'temml'
  s.version = Temml::VERSION
  s.authors = ['sudotac']
  s.email = ['sudo@tofuyard.net']

  s.summary = 'Renders Temml from Ruby.'
  s.description = 'Exposes Temml server-side renderer to Ruby.'
  s.homepage = 'https://github.com/sudotac/temml-ruby'
  s.license = 'CC0-1.0 AND MIT'

  s.required_ruby_version = '>= 3.2'

  s.files = Dir['{exe,lib,vendor,license}/**/*'] + %w[COPYING.txt README.md]
  s.bindir = 'exe'
  s.executables = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'execjs', '~> 2.7'

  s.metadata['rubygems_mfa_required'] = 'false' # rubocop:disable Gemspec/RequireMFA
end

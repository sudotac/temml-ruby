# frozen_string_literal: true

# The MIT License (MIT)
#
# Copyright (c) 2017 Gleb Mazovetskiy
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

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
  s.license = 'MIT'

  s.required_ruby_version = '>= 3.0'

  s.files = Dir['{exe,lib,vendor}/**/*'] + %w[LICENSE.txt README.md]
  s.bindir = 'exe'
  s.executables = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'execjs', '~> 2.7'

  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rubocop', '~> 1.0'
  s.add_development_dependency 'simplecov', '~> 0.22.0'

  s.metadata['rubygems_mfa_required'] = 'false' # rubocop:disable Gemspec/RequireMFA
end

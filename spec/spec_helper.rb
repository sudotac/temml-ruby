# frozen_string_literal: true

# SPDX-License-Identifier: CC0-1.0 AND MIT

if ENV['COVERAGE'] && !%w[rbx jruby].include?(RUBY_ENGINE)
  require 'simplecov'
  SimpleCov.command_name 'RSpec'
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'temml'

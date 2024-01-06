# frozen_string_literal: true

# SPDX-License-Identifier: CC0-1.0 AND MIT

unless defined?(RUBY_ENGINE) && %w[rbx jruby].include?(RUBY_ENGINE)
  SimpleCov.start do
    add_filter '/spec/'
    if ENV['CI']
      formatter SimpleCov::Formatter::SimpleFormatter
      add_group 'Libs', 'lib/'
      SimpleCov.at_exit do
        puts SimpleCov.result.format!
      end
    else
      formatter SimpleCov::Formatter::HTMLFormatter
    end
  end
end

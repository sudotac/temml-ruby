# frozen_string_literal: true

# SPDX-License-Identifier: CC0-1.0 AND MIT

require 'temml/version'
require 'execjs'
require 'erb'

# Provides a Ruby wrapper for Temml server-side rendering.
module Temml
  @load_context_mutex = Mutex.new
  @temml_context = nil
  @execjs_runtime = -> { ExecJS.runtime }

  class << self
    # rubocop:disable Naming/MethodParameterName, Naming/VariableName

    # Renders the given math expression to MathML via temml.renderToString.
    #
    # Additional options must be passed as anonymous keyword arguments.
    # See https://temml.org/docs/en/administration.html#options
    #
    # @param math [String] The math (Latex) expression
    # @param throwOnError [Boolean] Whether to raise on error. If false,
    #   renders the error message instead (even in case of ParseError, unlike
    #   the native temml).
    # @return [String] MathML. If strings respond to html_safe, the result will
    #   be HTML-safe.
    # @note This method is thread-safe as long as your ExecJS runtime is
    #   thread-safe. MiniRacer is the recommended runtime.
    def render(math, throwOnError: true, **)
      maybe_html_safe temml_context.call(
        'temml.renderToString',
        math,
        throwOnError:,
        **
      )
    rescue ExecJS::ProgramError => e
      raise e if throwOnError
    end
    # rubocop:enable Naming/MethodParameterName, Naming/VariableName

    # The ExecJS runtime factory, default: `-> { ExecJS.runtime }`.
    # Set this before calling any other methods to use a different runtime.
    #
    # This proc is guaranteed to be called at most once.
    attr_accessor :execjs_runtime

    def temml_context
      @load_context_mutex.synchronize do
        @temml_context ||= @execjs_runtime.call.compile File.read temml_js_path
      end
    end

    def temml_js_path
      File.expand_path File.join('vendor', 'temml', 'javascripts', 'temml.js'),
                       gem_path
    end

    def gem_path
      @gem_path ||=
        File.expand_path(File.join(File.dirname(__FILE__), '..'))
    end

    private

    def maybe_html_safe(html)
      if html.respond_to?(:html_safe)
        html.html_safe
      else
        html
      end
    end
  end
end

if defined?(Rails)
  require 'temml/engine'
else
  assets_path = File.join(Temml.gem_path, 'vendor', 'temml')
  if defined?(Sprockets)
    %w[fonts javascripts images].each do |subdirectory|
      path = File.join(assets_path, subdirectory)
      Sprockets.append_path(path) if File.directory?(path)
    end
    Sprockets.append_path(File.join(assets_path, 'sprockets', 'stylesheets'))
  elsif defined?(Hanami)
    Hanami::Assets.sources << assets_path
  end
end

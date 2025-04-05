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
    # rubocop:disable Metrics/MethodLength,Metrics/ParameterLists

    # Renders the given math expression to MathML via temml.renderToString.
    #
    # Additional options must be passed as anonymous keyword arguments.
    # See https://temml.org/docs/en/administration.html#options
    #
    # @param math [String] The math (Latex) expression
    # @param display_mode [Boolean] Whether to render in display mode.
    # @param annotate [Boolean] Whether to include an <annotation> element.
    # @param leqno [Boolean] Whether to render "\tag"s on the left
    #   instead of the right.
    # @param throw_on_error [Boolean] Whether to raise on error. If false,
    #   renders the error message instead (even in case of ParseError, unlike
    #   the native temml).
    # @param error_color [String] Error text CSS color.
    # @param macros [Hash] A collection of custom macros.
    # @return [String] MathML. If strings respond to html_safe, the result will
    #   be HTML-safe.
    # @note This method is thread-safe as long as your ExecJS runtime is
    #   thread-safe. MiniRacer is the recommended runtime.
    def render(math, display_mode: false, annotate: false, leqno: false,
               throw_on_error: true, error_color: '#b22222', macros: {},
               **)
      maybe_html_safe temml_context.call(
        'temml.renderToString',
        math,
        displayMode: display_mode,
        annotate:,
        leqno:,
        throwOnError: throw_on_error,
        errorColor: error_color,
        macros:,
        **
      )
    rescue ExecJS::ProgramError => e
      raise e if throw_on_error

      render_exception e, error_color
    end
    # rubocop:enable Metrics/MethodLength,Metrics/ParameterLists

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

    def render_exception(exception, error_color)
      maybe_html_safe <<~HTML
        <span class='temml-error' style='color: #{error_color}; white-space: pre-line;'>
          #{ERB::Util.h exception.message.sub(/^ParseError: /, '')}
        </span>
      HTML
    end

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

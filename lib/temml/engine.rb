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

module Temml
  # Registers Temml fonts, stylesheets, and javascripts with Rails.
  class Engine < ::Rails::Engine
    initializer 'temml.assets' do |app|
      # We deliberately do not place the assets in vendor/assets but in
      # vendor/temml instead, as vendor/assets is added to asset paths
      # by default but we have to avoid including the non-sprockets stylesheet.
      %w[fonts javascripts images].each do |sub|
        path = root.join('vendor', 'temml', sub).to_s
        app.config.assets.paths << path if File.directory?(path)
      end
      # Use sprockets versions of temml CSS that use asset-path for
      # referencing fonts.
      # One file is a Sass partial and the other one is .css.erb.
      app.config.assets.paths << root.join(
        'vendor', 'temml', 'sprockets', 'stylesheets'
      ).to_s
    end
  end
end

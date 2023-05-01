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

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc 'Update Temml from GitHub releases'
task :update, :version do |_task, args| # rubocop:disable Metrics/BlockLength
  require 'fileutils'
  require 'open-uri'

  # Download Temml
  version = args[:version]
  unless version
    warn 'Specify Temml version, e.g. rake update[0.10.11]'
    exit 64
  end
  dl_path = File.join('tmp', 'temml-dl', version)
  FileUtils.mkdir_p(dl_path)
  archive_path = File.join(dl_path, "v#{version}.tar.gz")
  unless File.exist?(archive_path)
    url = 'https://github.com/ronkok/Temml/archive/refs/tags/' \
          "v#{version}.tar.gz"
    IO.copy_stream(URI.open(url), archive_path)
  end
  temml_path = File.join(File.dirname(archive_path), "Temml-#{version}")
  unless File.directory?(temml_path)
    system 'tar', 'xf', archive_path, '-C', File.dirname(archive_path)
  end
  dist_path = File.join(temml_path, 'dist')

  # Copy assets
  assets_path = File.join('vendor', 'temml')
  FileUtils.rm_rf assets_path
  FileUtils.mkdir_p assets_path
  fonts_path = File.join(assets_path, 'fonts')
  FileUtils.mkdir_p fonts_path
  FileUtils.cp File.join(dist_path, 'Temml.woff2'), fonts_path
  if File.directory? File.join(dist_path, 'images')
    FileUtils.cp_r File.join(dist_path, 'images'), assets_path
  end
  js_path = File.join(assets_path, 'javascripts')
  FileUtils.mkdir_p js_path
  FileUtils.cp File.join(dist_path, 'temml.min.js'), js_path

  css_path = File.join(assets_path, 'stylesheets')
  FileUtils.mkdir_p css_path
  sprockets_css_path = File.join(assets_path, 'sprockets', 'stylesheets')
  FileUtils.mkdir_p sprockets_css_path
  %w[Local Asana Latin-Modern Libertinus STIX2].each do |variant|
    var_css = File.join(dist_path, "Temml-#{variant}.css")
    FileUtils.cp var_css, css_path

    # Create sprockets versions of temml CSS that use asset-path for referencing
    # fonts. One is a Sass version and the other one is .css.erb.
    asset_url_regex = %r{url\(['"]?(?:.\/)?([^'")]*)['"]?\)}
    css_content = File.read(var_css)
    File.write(File.join(sprockets_css_path, "_Temml-#{variant}.scss"),
               css_content.gsub(asset_url_regex, "url(asset-path('\\1'))"))
    File.write(File.join(sprockets_css_path, "Temml-#{variant}.css.erb"),
               css_content.gsub(asset_url_regex,
                                "url(<%= asset_path('\\1') %>)"))
  end

  # Update TEMML_VERSION in version.rb
  File.write('lib/temml/version.rb',
             File.read('lib/temml/version.rb')
                 .gsub(/TEMML_VERSION = '.*?'/,
                       "TEMML_VERSION = 'v#{version}'"))
end

task default: :spec

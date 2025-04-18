# frozen_string_literal: true

# SPDX-License-Identifier: CC0-1.0 AND MIT

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
    IO.copy_stream(URI.open(url), archive_path) # rubocop:disable Security/Open
  end
  temml_path = File.join(File.dirname(archive_path), "Temml-#{version}")
  system 'tar', 'xf', archive_path, '-C', File.dirname(archive_path) unless File.directory?(temml_path)
  dist_path = File.join(temml_path, 'dist')

  # Copy assets
  assets_path = File.join('vendor', 'temml')
  FileUtils.rm_rf assets_path
  FileUtils.mkdir_p assets_path
  fonts_path = File.join(assets_path, 'fonts')
  FileUtils.mkdir_p fonts_path
  FileUtils.cp File.join(dist_path, 'Temml.woff2'), fonts_path
  FileUtils.cp_r File.join(dist_path, 'images'), assets_path if File.directory? File.join(dist_path, 'images')
  js_path = File.join(assets_path, 'javascripts')
  FileUtils.mkdir_p js_path
  FileUtils.cp File.join(dist_path, 'temml.js'), js_path

  css_path = File.join(assets_path, 'stylesheets')
  FileUtils.mkdir_p css_path
  sprockets_css_path = File.join(assets_path, 'sprockets', 'stylesheets')
  FileUtils.mkdir_p sprockets_css_path
  %w[Local Asana Latin-Modern Libertinus NotoSans STIX2].each do |variant|
    var_css = File.join(dist_path, "Temml-#{variant}.css")
    FileUtils.cp var_css, css_path

    # Create sprockets versions of temml CSS that use asset-path for referencing
    # fonts. One is a Sass version and the other one is .css.erb.
    asset_url_regex = %r{url\(['"]?(?:./)?([^'")]*)['"]?\)}
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
                 .gsub(/TEMML_VERSION\s*=\s*'.*?'/,
                       "TEMML_VERSION = '#{version}'"))

  # Update CHANGES.md
  gem_version = Temml::VERSION.split('.').map(&:to_i)
  gem_version[1] += 1 # bump minor version
  File.write('CHANGES.md', <<~CHANGE.chomp
    # v#{gem_version[0]}.#{gem_version[1]}.#{gem_version[2]}

    * Import Temml v#{version}

    #{File.read('CHANGES.md')}
  CHANGE
  )
end

desc 'Bump version of this gem'
task :bump, :version do |_task, args|
  version = args[:version]

  # Update VERSION in version.rb
  File.write('lib/temml/version.rb',
             File.read('lib/temml/version.rb')
                 .gsub(/(?<!TEMML_)VERSION\s*=\s*'.*?'/,
                       "VERSION = '#{version}'"))

  # Update Gemfile example in README.md
  File.write('README.md',
             File.read('README.md')
                 .gsub(/gem\s+'temml'\s*,\s*'~>\s*\S+'\s*,\s*(.*),\s*:tag\s*=>\s*'v\S+'/,
                       "gem 'temml', '~> #{version}', \\1, :tag => 'v#{version}'")
                 .gsub(/gem\s+specific_install\s+-t\s+v\S+/,
                       "gem specific_install -t v#{version}"))
end

task default: :spec

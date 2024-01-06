# frozen_string_literal: true

# SPDX-License-Identifier: CC0-1.0 AND MIT

require 'spec_helper'

describe Temml do
  it 'has a version number' do
    expect(Temml::VERSION).not_to be nil
    expect(Temml::TEMML_VERSION).not_to be nil
  end

  it 'renders via temml' do
    expect(Temml.render('c = \\pm\\sqrt{a^2 + b^2}')).to include('<math>')
  end

  it 'passes options to temml' do
    expect(Temml.render('c', display_mode: true)).to \
      include('<math display="block"')
  end
end

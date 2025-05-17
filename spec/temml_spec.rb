# frozen_string_literal: true

# SPDX-License-Identifier: CC0-1.0 AND MIT

require 'execjs'
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
    expect(Temml.render('c', displayMode: true)).to \
      include('<math display="block"')
  end

  it 'throw exception on error (or not)' do
    expect { Temml.render('e^{i\pi') }.to raise_error(ExecJS::ProgramError)
    expect { Temml.render('e^{i\pi', throwOnError: false) }.not_to raise_error
  end
end

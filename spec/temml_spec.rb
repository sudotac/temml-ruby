# frozen_string_literal: true

# SPDX-License-Identifier: CC0-1.0 AND MIT

require 'execjs'
require 'nokogiri'
require 'spec_helper'

describe Temml do
  it 'has a version number' do
    expect(Temml::VERSION).not_to be nil
    expect(Temml::TEMML_VERSION).not_to be nil
  end

  it 'renders via temml' do
    frag = Nokogiri::HTML.fragment(Temml.render('c = \\pm\\sqrt{a^2 + b^2}'))
    expect(frag.elements[0].name).to eq('math')
  end

  it 'passes display option to temml' do
    frag = Nokogiri::HTML.fragment(Temml.render('\int_0^1 \frac{dx}{1+x^2} = \frac{\pi}{4}', displayMode: true))
    expect(frag.elements[0].name).to eq('math')
    expect(frag.elements[0][:display]).to include('block')
  end

  it 'throw exception on error (or not)' do
    expect { Temml.render('e^{i\pi') }.to raise_error(ExecJS::ProgramError)
    expect { Temml.render('e^{i\pi', throwOnError: false) }.not_to raise_error
    expect { Temml.render('\UnsupportedFunctionNameLikeThat') }.to raise_error(ExecJS::ProgramError)
    expect { Temml.render('\UnsupportedFunctionNameLikeThat', throwOnError: false) }.not_to raise_error
  end
end

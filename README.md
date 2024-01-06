# Temml for Ruby

[![](https://github.com/sudotac/temml-ruby/actions/workflows/lint-and-test.yml/badge.svg)](https://github.com/sudotac/temml-ruby/actions/workflows/lint-and-test.yml)

temml-ruby is a fork of [katex-ruby], focusing on the support of [Temml] instead of [KaTeX].

This rubygem enables you to render TeX math to MathML using [Temml].
It uses [ExecJS] under the hood.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'temml', '~> 0.11.0', :github => 'sudotac/temml-ruby'
```

And then execute:

    $ bundle

Or install it yourself with [specific\_install rubygem](https://rubygems.org/gems/specific_install) as:

    $ gem specific_install -t v0.11.0 https://github.com/sudotac/temml-ruby.git

## Usage

Render some math:

```ruby
Temml.render('c = \\pm\\sqrt{a^2 + b^2}')
=> "<math><mrow><mi>c</mi><mo>=</mo></mrow><mrow><mo>±</mo></mrow><mrow><msqrt><mrow><msup><mi>a</mi><mn>2</mn></msup><mo>+</mo><msup><mi>b</mi><mn>2</mn></msup></mrow></msqrt></mrow></math>"
```

If you're on Rails, the result is marked as `html_safe`.

Any error in the markup is raised by default. To avoid this and render error
text instead, pass `throw_on_error: false`:

```ruby
Temml.render '\\', throw_on_error: false
=> "<span class=\"temml-error\" style=\"color:#b22222;white-space:pre-line;\">\\\nParseError:  Unexpected character: &#x27;\\&#x27; at position 1: \\̲</span>"
```

Note that this will catch even `ParseError`s (unlike native Temml).

### Assets

For this rendered math to look nice, you will also need to include Temml CSS
and web fonts into the webpage.

I recommend you use the CSS bundled with this gem, to ensure version
compatibility.

You also need to include the appropriate web fonts for the CSS
you have chosen to use.
Please refer to [Temml's documentation](https://temml.org/docs/en/administration.html#fonts)
for details.

#### Automatic registrations

If you use Rails, Sprockets without Rails, or Hanami, the assets are registered
automatically.

For example, if you want to use Latin Modern font,
`//= require Temml-Latin-Modern` if you use CSS or `@import "_Temml-Latin-Modern"` if you use Sass.

You can also `//= require temml` in your JS to access the Temml renderer in the
browser.

#### Manual registration

The assets are located in the `vendor/assets` directory of the gem. The root
path to the root directory of the gem is available via `Temml.gem_path`, e.g.:

```ruby
File.join(Temml.gem_path, 'vendor', 'assets')
```

### Temml version

The version of Temml bundled with this gem is available via:

```ruby
Temml::TEMML_VERSION
```

### Caching

If you cache the output of `Temml.render`, make sure to use the Temml
version in the cache key, as the output may change between versions.

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/sudotac/temml-ruby.

This project is intended to be a safe, welcoming space for collaboration,
and contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

This gem is based on [katex-ruby] and my contribution is tiny and trivial,
so I will make this gem available under the terms of [CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/).

Note that you should still have to follow the licenses of [katex-ruby], [Temml] and [KaTeX],
which are distributed under the terms of the [MIT License](http://opensource.org/licenses/MIT).
See the license files in the [license](license) directory.

[katex-ruby]: https://github.com/glebm/katex-ruby
[KaTeX]: https://github.com/Khan/KaTeX
[Temml]: https://github.com/ronkok/Temml
[ExecJS]: https://github.com/rails/execjs

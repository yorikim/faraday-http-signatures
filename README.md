[![Travis](https://api.travis-ci.org/CurrencyCloud/faraday-http-signatures.svg)](https://travis-ci.org/CurrencyCloud/faraday-http-signatures)

# faraday-http-signatures
Faraday middleware that implement draft 5 of the HTTP Signatures spec

## Installation

You don't need this source code unless you want to modify the gem. If you just want to use the library in your application, you should run:

```bash
gem install faraday-http-signatures
```

Or add gem to your Gemfile:

```ruby
gem 'faraday-http-signatures'
```

If you want to build the gem from source:

```bash
gem build faraday-http-signatures.gemspec
```

## Example

``` rb
require 'faraday'
require 'faraday/http/signatures'

options = {
  digest_header: 'digest',
  digest_algorithm: 'sha256',
  signature_header: 'authorization',
  signature_algorithm: 'rsa-sha256',
  headers: '(request-target) host digest'
}

conn = Faraday.new(url: 'http://localhost:9292') do |faraday|
  faraday.request :http_signatures, 'Test', File.read('spec/support/fixtures/rsa256/private.pem'), options
  faraday.adapter Faraday.default_adapter
end

response = conn.post('/') do |r|
  r.body = '{"hello": "world"}'
end

#request_headers =
#  {"User-Agent"=>"Faraday v0.9.2",
#   "digest"=>"sha-256=X48E9qOokqqrvdts8nOJRJN3OWDUoyWxBf7kbu9DBPE=",
#   "authorization"=>
#    "Signature keyId=\"Test\",algorithm=\"rsa-sha256\",headers=\"(request-target) host digest\",signature=\"d6J8r8dcObif5YEU8Vr1Vu3kRw8VzFyCbXRl/jv2ZQ/yBvz5AbwNLbeadgM+dsewFDaNyreeaccEnsv4mzZfomk0XGE6VKHP6kf1+ZJhLMqMm2hYchyrXmrl7DFZiwk6ecGZOxe17PZOidIic3seLP/unq5Seb86hjCV7VAYNG4=\""},

```

## Supported algorithms:
### Digest
* SHA-256 (sha-256)

### Signature
* RSA-SHA256 (rsa-sha256)
* HMAC-SHA256 (hmac-sha256)

Note: ecdsa-sha256 **IS NOT** supported.

## Supported Ruby versions
This library aims to support and is [tested against][travis] the following Ruby
implementations:
* MRI 1.9.3
* MRI 2.0.0
* MRI 2.1.0
* MRI 2.2.0
* [JRuby][jruby]
* [Rubinius][rubinius]

[travis]:    https://travis-ci.org/CurrencyCloud/faraday-http-signatures
[jruby]:     http://jruby.org/
[rubinius]:  http://rubini.us/
[license]:   LICENSE.md

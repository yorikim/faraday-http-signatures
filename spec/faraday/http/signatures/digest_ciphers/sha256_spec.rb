require 'spec_helper'
require 'base64'

describe Faraday::Http::Signatures::DigestCiphers::SHA256 do
  it 'encrypts the message' do
    expect(Base64.strict_encode64(described_class.encrypt('{"hello": "world"}'))).to eq('X48E9qOokqqrvdts8nOJRJN3OWDUoyWxBf7kbu9DBPE=')
  end
end

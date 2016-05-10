require 'openssl'

describe Faraday::Http::Signatures::SignatureCiphers::RSA256 do
  let(:private_key) { File.read('spec/support/fixtures/rsa256/private.pem') }
  let(:valid_signature) { 'jKyvPcxB4JbmYY4mByyBY7cZfNl4OW9HpFQlG7N4YcJPteKTu4MWCLyk+gIr0wDgqtLWf9NLpMAMimdfsH7FSWGfbMFSrsVTHNTk0rK3usrfFnti1dxsM4jl0kYJCKTGI/UWkqiaxwNiKqGcdlEDrTcUhhsFsOIo8VhddmZTZ8w=' }
  let(:message) { 'date: Thu, 05 Jan 2014 21:31:40 GMT' }

  it 'encrypts the message' do
    expect(Base64.strict_encode64(described_class.encrypt(private_key, message))).to eq(valid_signature)
  end
end

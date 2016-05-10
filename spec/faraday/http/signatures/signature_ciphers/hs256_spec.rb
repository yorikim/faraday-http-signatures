require 'openssl'

describe Faraday::Http::Signatures::SignatureCiphers::HS256 do
  let(:private_key) { File.read('spec/support/fixtures/hs256/key.txt') }
  let(:valid_signature) { 'NzU4ZDAyMGRmNzQxZmQ3NDQ0YWY0Mzk5Y2YxMjUzYzA1NGI2MWQ2OTc5NjhlYjM3NTg2Y2I1MmFiMDlkN2NkNA==' }
  let(:message) { 'date: Thu, 05 Jan 2014 21:31:40 GMT' }

  it 'encrypts the message' do
    expect(Base64.strict_encode64(described_class.encrypt(private_key, message))).to eq(valid_signature)
  end
end

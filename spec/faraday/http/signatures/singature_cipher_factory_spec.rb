require 'spec_helper'

describe Faraday::Http::Signatures::SignatureCipherFactory do
  { 'hmac-sha256' => Faraday::Http::Signatures::SignatureCiphers::HS256,
    'rsa-sha256'  => Faraday::Http::Signatures::SignatureCiphers::RSA256
  }.each do |algorithm, klass|
    it "returns #{algorithm}" do
      expect(described_class.create(algorithm)).to eq(klass)
    end
  end

  it 'raises UnknownAlgorithmError' do
    expect { described_class.create('unknown-algorithm') }.to raise_error(described_class::UnknownAlgorithmError, 'Unknown Signature algorithm')
  end
end

require 'spec_helper'

describe Faraday::Http::Signatures::DigestCipherFactory do
  { 'sha-256' => Faraday::Http::Signatures::DigestCiphers::SHA256 }.each do |algorithm, klass|
    it "returns #{algorithm}" do
      expect(described_class.create(algorithm)).to eq(klass)
    end
  end

  it 'raises UnknownAlgorithmError' do
    expect { described_class.create('unknown-algorithm') }.to raise_error(described_class::UnknownAlgorithmError, 'Unknown Digest algorithm')
  end
end

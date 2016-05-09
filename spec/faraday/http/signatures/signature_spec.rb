require 'spec_helper'
require 'pp'

describe Faraday::Http::Signatures::Signature do
  let(:options) { {} }
  let(:conn) do
    Faraday.new do |builder|
      builder.request :http_signatures, 'Test', File.read('spec/support/fixtures/rsa256/private.pem'), options
      builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post('/digest') { |env| [200, env[:request_headers], env[:body]] }
      end
    end
  end

  context 'digest header' do
    let(:body) { '{"hello": "world"}' }
    let(:digest) { 'X48E9qOokqqrvdts8nOJRJN3OWDUoyWxBf7kbu9DBPE=' }

    context 'valid algorithm' do
      it 'creates digest from body' do
        response = conn.post('/digest') { |request| request.body = body }
        expect(response.headers['Digest']).to eq("SHA-256=#{digest}")
      end

      it 'creates digest with empty body' do
        response = conn.post('/digest') { |request| request.body = nil }
        expect(response.headers['Digest']).to eq('SHA-256=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=')
      end
    end

    context 'invalid algorithm' do
      let(:options) do
        { digest_algorithm: 'unknown algorithm' }
      end

      it 'raise error' do
        unknown_algorithm = Faraday::Http::Signatures::DigestCipherFactory::UnknownAlgorithmError
        expect { conn.post('/digest') }.to raise_error(unknown_algorithm, 'Unknown Digest algorithm')
      end
    end
  end
end

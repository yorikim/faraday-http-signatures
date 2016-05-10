require 'spec_helper'
require 'pp'

describe Faraday::Http::Signatures::Signature do
  let(:options) { { headers: '(request-target) host date content-type digest content-length' } }
  let(:body) { '{"hello": "world"}' }

  let(:request_headers) do
    { 'Date'         => 'Thu, 05 Jan 2014 21:31:40 GMT',
      'Content-Type' => 'application/json'
    }
  end

  context 'create digest' do
    let(:digest) { 'X48E9qOokqqrvdts8nOJRJN3OWDUoyWxBf7kbu9DBPE=' }

    context 'with valid algorithm' do
      it 'creates digest from body' do
        response = send_request(body)
        expect(response.headers['Digest']).to eq("SHA-256=#{digest}")
      end

      it 'creates digest with empty body' do
        response = send_request(nil)
        expect(response.headers['Digest']).to eq('SHA-256=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=')
      end
    end

    context 'invalid algorithm' do
      let(:options) { { digest_algorithm: 'unknown algorithm' } }

      it 'raise error' do
        unknown_algorithm = Faraday::Http::Signatures::DigestCipherFactory::UnknownAlgorithmError
        expect { send_request(body) }.to raise_error(unknown_algorithm, 'Unknown Digest algorithm')
      end
    end
  end

  context 'create signature' do
    context 'from header list with custom header name' do
      context 'rsa-sha256 (default)' do
        let(:options) do
          { headers:          '(request-target) host date content-type digest content-length',
            signature_header: 'Auth'
          }
        end

        it 'creates signature' do
          response = send_request(body)
          expect(response.headers['Auth']).to eq('Signature keyId="Test",algorithm="rsa-sha256",headers="(request-target) host date content-type digest content-length",signature="Ef7MlxLXoBovhil3AlyjtBwAL9g4TN3tibLj7uuNB3CROat/9KaeQ4hW2NiJ+pZ6HQEOx9vYZAyi+7cmIkmJszJCut5kQLAwuX+Ms/mUFvpKlSo9StS2bMXDBNjOh4Auj774GFj4gwjS+3NhFeoqyr/MuN6HsEnkvn6zdgfE2i0="')
        end
      end

      context 'hmac-sha256' do
        let(:options) do
          { headers:             '(request-target) host date content-type digest content-length',
            signature_header:    'Auth',
            signature_algorithm: 'hmac-sha256'
          }
        end

        it 'creates signature with hmac-sha256' do
          conn     = connection('spec/support/fixtures/hs256/key.txt')
          response = send_request(body, conn)
          expect(response.headers['Auth']).to eq('Signature keyId="Test",algorithm="hmac-sha256",headers="(request-target) host date content-type digest content-length",signature="M2Q2ODg4ZDU4ZjAxODgyNWJlMjY1ZmI3YTg2NWM2Nzc1ZDA5MzhiMWRkOTk3MzJkMGZmMWVjY2U0YmNmNDFiMA=="')
        end
      end

      context 'invalid algorithm' do
        let(:options) do
          { headers:             '(request-target) host date content-type digest content-length',
            signature_algorithm: 'invalid algorithm'
          }
        end

        it 'raises unknown algorithm error' do
          unknown_algorithm = Faraday::Http::Signatures::SignatureCipherFactory::UnknownAlgorithmError
          expect { send_request(body) }.to raise_error(unknown_algorithm, 'Unknown Signature algorithm')
        end
      end
    end

    context 'from all headers' do
      let(:options) { { headers: 'All headers' } }

      it 'creates signature by default (all http headers)' do
        response = send_request(body)
        expect(response.headers['Authorization']).to eq('Signature keyId="Test",algorithm="rsa-sha256",headers="(request-target) host user-agent date content-type digest content-length",signature="W6pRJE1tyY6hIuksffqMjA3HNwIIQC+8n3OXDThaAV9ZrWlkaIKHoIG24LQKpHd7axx7D0pzPA4nUX171aw32QdxLWx67K5aFSnsI9SPiYvU0DgGCUg5VrELQI9d9dZo69iaqxAfBTsQkm6uxHs0hv/Sdu4A84oYE27BT2NDoh4="')
      end
    end
  end

  def send_request(body, conn = nil)
    conn = connection unless conn
    conn.post('http://example.com/foo?param=value&pet=dog') do |request|
      request[:date]         = request_headers['Date']
      request[:content_type] = request_headers['Content-Type']
      request.body           = body
    end
  end

  def connection(key_path = 'spec/support/fixtures/rsa256/private.pem')
    Faraday.new do |builder|
      builder.request :http_signatures, 'Test', File.read(key_path), options
      builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post('http://example.com/foo?param=value&pet=dog') { |env| [200, env[:request_headers], env[:body]] }
      end
    end
  end
end

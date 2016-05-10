require 'faraday/http/signatures/digest_cipher_factory'
require 'base64'

module Faraday
  module Http
    module Signatures
      class DigestSigner
        def initialize(digest_header, algorithm, env)
          @signature_header = digest_header
          @algorithm        = algorithm
          @env              = env.dup
        end

        def signed_env
          @env[:request_headers][@signature_header] = "#{@algorithm}=#{digest_base64}"
          @env
        end

        private

        def digest_base64
          @digest_base64 ||= Base64.strict_encode64(digest)
        end

        def digest
          @digest ||= DigestCipherFactory.create(@algorithm).encrypt(body)
        end

        def body
          @env[:body] || ''
        end
      end
    end
  end
end

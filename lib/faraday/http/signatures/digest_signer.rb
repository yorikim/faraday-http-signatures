require 'faraday/http/signatures/digest_cipher_factory'
require 'base64'

module Faraday
  module Http
    module Signatures
      class DigestSigner
        def initialize(digest_header, algorithm, env)
          @digest_header = digest_header
          @algorithm     = algorithm
          @env           = env.dup
        end

        def signed_env
          print_warn if @env[:request_headers].key?(@digest_header)
          @env[:request_headers][@digest_header] = "#{@algorithm}=#{digest_base64}"
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

        def print_warn
          warn "WARNING:  Header '#{@digest_header}' is overwritten"
        end
      end
    end
  end
end

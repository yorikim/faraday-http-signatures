require 'faraday/http/signatures/signature_ciphers/hs256'
require 'faraday/http/signatures/signature_ciphers/rsa256'

module Faraday
  module Http
    module Signatures
      class SignatureCipherFactory
        UnknownAlgorithmError = Class.new(ArgumentError)
        VALID_ALGORITHMS      = %w(rsa-sha256 hmac-sha256).freeze

        class << self
          def create(algorithm)
            case algorithm.downcase
            when 'rsa-sha256' then
              SignatureCiphers::RSA256
            when 'hmac-sha256' then
              SignatureCiphers::HS256
            else
              raise UnknownAlgorithmError, 'Unknown Signature algorithm'
            end
          end
        end
      end
    end
  end
end

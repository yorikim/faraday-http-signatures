require 'faraday/http/signatures/digest_ciphers/sha256'

module Faraday
  module Http
    module Signatures
      class DigestCipherFactory
        UnknownAlgorithmError = Class.new(ArgumentError)
        VALID_ALGORITHMS      = %w(sha-256).freeze

        class << self
          def create(algorithm)
            case algorithm.downcase
            when 'sha-256' then
              DigestCiphers::SHA256
            else
              raise UnknownAlgorithmError, 'Unknown Digest algorithm'
            end
          end
        end
      end
    end
  end
end

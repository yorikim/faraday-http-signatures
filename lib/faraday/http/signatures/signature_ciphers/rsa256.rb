require 'openssl'

module Faraday
  module Http
    module Signatures
      module SignatureCiphers
        class RSA256
          class << self
            DIGEST = OpenSSL::Digest::SHA256.new

            def encrypt(key, data)
              private_key = OpenSSL::PKey::RSA.new(key)
              private_key.sign(DIGEST, data)
            end
          end
        end
      end
    end
  end
end

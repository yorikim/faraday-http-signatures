require 'openssl'

module Faraday
  module Http
    module Signatures
      module SignatureCiphers
        class HS256
          class << self
            DIGEST = OpenSSL::Digest::SHA256.new

            def encrypt(key, data)
              OpenSSL::HMAC.hexdigest(DIGEST, key, data)
            end
          end
        end
      end
    end
  end
end

require 'openssl'

module Faraday
  module Http
    module Signatures
      module DigestCiphers
        module SHA256
          class << self
            def encrypt(message)
              sha256 = OpenSSL::Digest::SHA256.new
              sha256 << message
              sha256.digest
            end
          end
        end
      end
    end
  end
end

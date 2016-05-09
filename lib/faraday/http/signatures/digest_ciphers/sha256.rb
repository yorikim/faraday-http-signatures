require 'openssl'

module Faraday
  module Http
    module Signatures
      module DigestCiphers
        module SHA256
          class << self
            SHA256 = OpenSSL::Digest::SHA256.new

            def encrypt(message)
              SHA256.reset
              SHA256 << message
              SHA256.digest
            end
          end
        end
      end
    end
  end
end

module Faraday
  module Http
    module Signatures
      require 'faraday/http/signatures/version'
      require 'faraday/http/signatures/signature'

      Faraday::Request.register_middleware \
        http_signatures: -> { Signature }
    end
  end
end

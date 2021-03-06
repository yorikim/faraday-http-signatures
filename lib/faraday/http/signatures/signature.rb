require 'faraday'
require 'faraday/http/signatures/config'
require 'faraday/http/signatures/digest_signer'
require 'faraday/http/signatures/signature_signer'

module Faraday
  module Http
    module Signatures
      class Signature < Faraday::Middleware
        def initialize(app, key_id, private_key, options = {})
          super(app)
          @config = Faraday::Http::Signatures::Config.new(key_id, private_key, options)
        end

        def call(env)
          signed_env = digest_signer(env).signed_env
          signed_env = signature_signer(signed_env).signed_env
          @app.call(signed_env)
        end

        private

        def digest_signer(env)
          DigestSigner.new(@config.digest_header, @config.digest_algorithm, env)
        end

        def signature_signer(env)
          SignatureSigner.new(@config, env)
        end
      end
    end
  end
end

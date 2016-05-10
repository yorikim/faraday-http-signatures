require 'faraday/http/signatures/signature_cipher_factory'
require 'base64'

module Faraday
  module Http
    module Signatures
      class SignatureSigner
        def initialize(config, env)
          @env              = env.dup
          @key_id           = config.key_id
          @private_key      = config.private_key
          @headers          = config.headers == 'All headers' ? all_headers : config.headers.split(' ')
          @signature_header = config.signature_header
          @algorithm        = config.signature_algorithm
        end

        def signed_env
          print_warn if @env[:request_headers].key?(@signature_header)
          @env[:request_headers][@signature_header] = authorization_header_value
          @env
        end

        private

        def signature_base64
          @signature_base64 ||= Base64.strict_encode64(signature)
        end

        def signature
          @signature ||= SignatureCipherFactory.create(@algorithm).encrypt(@private_key, signed_data)
        end

        def signed_data
          @signed_data ||= @headers.map do |header|
            case header.downcase
            when '(request-target)' then
              "#{header}: #{@env[:method]} #{relative_url}"
            when 'host' then
              "#{header}: #{@env[:url].hostname}"
            when 'content-length' then
              "#{header}: #{body.size}"
            else
              raise ArgumentError, "header '#{header}' not found" unless @env[:request_headers].key?(header)
              "#{header}: #{@env[:request_headers][header]}"
            end
          end.join("\n")
        end

        def authorization_header_value
          'Signature ' \
            "keyId=\"#{@key_id}\"," \
            "algorithm=\"#{@algorithm.downcase}\"," \
            "headers=\"#{@headers.join(' ')}\"," \
            "signature=\"#{signature_base64}\""
        end

        def relative_url
          "#{@env[:url].request_uri}#{"##{@env[:url].fragment}" if @env[:url].fragment}"
        end

        def all_headers
          header_list = %w((request-target) host)
          @env[:request_headers].each { |header, _value| header_list << header.downcase }
          header_list << 'content-length' unless body.empty?
        end

        def body
          @env[:body] || ''
        end

        def print_warn
          warn "WARNING:  Header '#{@signature_header}' is overwritten"
        end
      end
    end
  end
end

module Faraday
  module Http
    module Signatures
      class Config
        attr_reader :key_id, :private_key

        def initialize(key_id, private_key, options = {})
          @key_id      = key_id
          @private_key = private_key
          @options     = default_options.merge(options)
        end

        def self.options_accessor(*names) #:nodoc:
          names.each do |name|
            class_eval <<-METHOD, __FILE__, __LINE__ + 1
          def #{name}
            @options[:#{name}]
          end
          def #{name}=(value)
            @options[:#{name}] = value
          end
            METHOD
          end
        end

        options_accessor :digest_header, :digest_algorithm, :signature_header, :signature_algorithm

        private

        def default_options
          { signature_algorithm: 'RSA-SHA256',
            signature_header:    'Authorization',
            digest_algorithm:    'SHA-256',
            digest_header:       'Digest'
          }
        end
      end
    end
  end
end

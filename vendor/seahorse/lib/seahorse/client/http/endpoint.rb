require 'uri'

module Seahorse
  module Client
    module Http

      # # Constructing an Endpoint
      #
      # You can construct an endpoint from a string like so:
      #
      #     puts Endpoint.new('http://foo.com:123')
      #     #=> 'http://foo.com'
      #
      # If you omit the protocol, it will default to a HTTPS endpoint:
      #
      #     puts Endpoint.new('foo.com')
      #     #=> 'https://foo.com'
      #
      # You can default to a HTTP endpoint by passing `:ssl_default` as `false`:
      #
      #     puts Endpoint.new('foo.com', ssl_default: false)
      #     #=> 'http://foo.com'
      #
      class Endpoint

        # @param [Endpoint, String] endpoint
        # @option options [Boolean] :ssl_default (true)
        def initialize(endpoint, options = {})
          endpoint = endpoint.to_s
          unless endpoint =~ /^http/
            endpoint = apply_scheme(endpoint, options)
          end
          URI.parse(endpoint).tap do |uri|
            @scheme = uri.scheme
            @host = uri.host
            @port = uri.port
            @user = uri.user
            @password = uri.password
          end
        end

        # @return [String] Returns the endpoint scheme ('https' or 'http').
        attr_accessor :scheme

        # @return [String] Returns the endpoint host (e.g. 'foo.com')
        attr_accessor :host

        # @return [Integer] Returns the endpoint port number (e.g. 443).
        attr_accessor :port

        # @return [String, nil]
        attr_accessor :user

        # @return [String, nil]
        attr_accessor :password

        # @return [Boolean]
        def http?
          @scheme == 'http'
        end

        # @return [Boolean]
        def https?
          @scheme == 'https'
        end

        # @return [String]
        # @api private
        def inspect
          URI.parse("#{@scheme}://#{userpass}#{@host}:#{@port}").to_s
        end
        alias to_str inspect
        alias to_s inspect

        # @return [Boolean]
        # @api private
        def eq(other)
          to_s == other.to_s
        end
        alias == eq

        private

        def apply_scheme(endpoint, options)
          "http#{options.fetch(:ssl_default, true) ? 's' : ''}://#{endpoint}"
        end

        def userpass
          [@user, @password].compact.join(':') + '@' if @user
        end

      end
    end
  end
end

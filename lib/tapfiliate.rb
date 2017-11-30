# frozen_string_literal: true

require 'http'
require 'json'
require 'addressable/template'
require 'forwardable'
require 'dotenv'

require 'tapfiliate/version'
require 'tapfiliate/configuration'
require 'tapfiliate/constants'
require 'tapfiliate/conversion'
require 'tapfiliate/commission'
require 'tapfiliate/program'
require 'tapfiliate/affiliate'

# Tapfiliate module
module Tapfiliate
  class Error < ::StandardError; end
  class ConfigurationError < Error; end
  class HTTPError < Error; end
  class TimeoutError < Error; end
  class InvalidArgumentsError < Error; end

  class << self
    extend Forwardable
    attr_writer :configuration

    def configuration
      @_configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def_delegators :configuration, :base_url, :api_key

    def endpoint(name, **expansions)
      Addressable::Template.new(Tapfiliate::ENDPOINTS[name])
                           .expand(**expansions)
    end

    def conversion(**args)
      Conversion.fetch(**args)
    end

    def conversions(**args)
      Conversion.fetch_all(**args)
    end

    def program(**args)
      Program.fetch(**args)
    end

    def programs
      Program.fetch_all
    end

    def affiliate(**args)
      Affiliate.fetch(**args)
    end

    def affiliates(**args)
      Affiliate.fetch_all(**args)
    end

    def create_affiliate(**args)
      Affiliate.create(**args)
    end

    def request(data_params: {}, http_method:, uri:)
      raise ConfigurationError, 'Missing tapfiliate base URL' if base_url.nil? || base_url.empty?
      raise ConfigurationError, 'Missing tapfiliate api key' if api_key.nil? || api_key.empty?
      valid_status_for = {
        post: [200, 204],
        patch: [200, 204],
        get: [200, 404]
      }
      http_call = HTTP.headers(
        accept: 'application/json',
        content_type: 'application/json',
        api_key: api_key
      )
      response = http_call.send(http_method, base_url + uri, json: data_params)
      raise Error, "Tapfiliate API returned invalid status for #{http_method}: #{response.status} #{response.body}" unless valid_status_for[http_method.to_sym].include?(response.status)
      return nil if [204, 404].include?(response.status)
      JSON.parse(response.body, symbolize_names: true)
    rescue HTTP::Error => e
      raise HTTPError, "API error calling #{base_url + uri} (#{e.message})"
    rescue HTTP::TimeoutError => e
      raise TimeoutError, "Tapfiliate timeout calling #{base_url + uri} (#{e.message})"
    end
  end
end

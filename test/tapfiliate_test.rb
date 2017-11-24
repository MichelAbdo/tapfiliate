# frozen_string_literal: true

require 'test_helper'

class TapfiliateTest < Minitest::Test
  describe '#version' do
    it 'checks that it has a version number' do
      refute_nil ::Tapfiliate::VERSION
    end
  end

  describe '#configure' do
    it 'set the base url and api key when the Tapfiliate class is configured' do
      Tapfiliate.configure do |config|
        config.base_url = ENV['TAPFILIATE_API_BASE_URL']
        config.api_key = ENV['TAPFILIATE_API_KEY']
      end
      assert_equal Tapfiliate.base_url, ENV['TAPFILIATE_API_BASE_URL']
      assert_equal Tapfiliate.api_key, ENV['TAPFILIATE_API_KEY']
    end
  end

  describe '#request' do
    it 'raises a ConfigurationError if the tapfiliate base URL is not set' do
      Tapfiliate.configure { |config| config.base_url = nil }
      base_url_exception = assert_raises(Tapfiliate::ConfigurationError) do
        Tapfiliate.request(
          uri: Tapfiliate.endpoint(:programs),
          http_method: 'get'
        )
      end
      assert_equal('Missing tapfiliate base URL', base_url_exception.message)
      Tapfiliate.configure do |config|
        config.base_url = ENV['TAPFILIATE_API_BASE_URL']
      end
    end

    it 'raises a ConfigurationError if the tapfiliate api key is not set' do
      Tapfiliate.configure { |config| config.api_key = nil }
      api_key_exception = assert_raises(Tapfiliate::ConfigurationError) do
        Tapfiliate.request(
          uri: Tapfiliate.endpoint(:programs),
          http_method: 'get'
        )
      end
      assert_equal 'Missing tapfiliate api key', api_key_exception.message
      Tapfiliate.configure do |config|
        config.api_key = ENV['TAPFILIATE_API_KEY']
      end
    end

    it 'raises an error on timeout' do
      WebMock.stub_request(
        :get, ENV['TAPFILIATE_API_BASE_URL'] + Tapfiliate.endpoint(:programs)
      ).to_timeout
      assert_raises(Tapfiliate::Error) do
        Tapfiliate.request(
          uri: Tapfiliate.endpoint(:programs),
          http_method: 'get'
        )
      end
      WebMock.reset!
    end

    it 'Returns nil if the response has a status 404' do
      response = Tapfiliate.request(
        uri: Tapfiliate.endpoint(:conversion, id: 111),
        http_method: 'get'
      )
      assert_nil response
    end

    it 'Returns a hash when the api call is successful' do
      response = Tapfiliate.request(
        uri: Tapfiliate.endpoint(:programs),
        http_method: 'get'
      )
      assert response
      assert response.first
      assert response.first[:id]
    end

    it 'raises an error exception for http errors' do
      WebMock.stub_request(
        :get, ENV['TAPFILIATE_API_BASE_URL'] + Tapfiliate.endpoint(:programs)
      ).to_return(status: [500, 'Internal Server Error'])
      assert_raises(Tapfiliate::Error) do
        Tapfiliate.request(
          uri: Tapfiliate.endpoint(:programs),
          http_method: 'get'
        )
      end
      WebMock.reset!
    end
  end

  describe '#conversion' do
    it 'fetches a conversion by id and instantiates it' do
      conversion_id = ENV['TEST_CONVERSION_ID'].to_i
      conversion = Tapfiliate.conversion(id: conversion_id)
      assert_instance_of Tapfiliate::Conversion, conversion
      assert_equal conversion_id, conversion.id
    end
  end

  describe '#conversions' do
    it 'fetches conversions and returns a hash of conversion instances' do
      conversions = Tapfiliate.conversions
      assert_instance_of Tapfiliate::Conversion, conversions.first
    end
  end

  describe '#program' do
    it 'fetches a program by id and instantiates it' do
      program_id = ENV['TEST_PROGRAM_ID']
      program = Tapfiliate.program(id: program_id)
      assert_instance_of Tapfiliate::Program, program
      assert_equal program_id, program.id
    end
  end

  describe '#programs' do
    it 'fetches programs and returns a hash of program instances' do
      programs = Tapfiliate.programs
      assert_instance_of Tapfiliate::Program, programs.first
    end
  end

  describe '#affiliate' do
    it 'fetches an affiliate by id and instantiates it' do
      affiliate_id = ENV['TEST_AFFILIATE_ID']
      affiliate = Tapfiliate.affiliate(id: affiliate_id)
      assert_instance_of Tapfiliate::Affiliate, affiliate
      assert_equal affiliate_id, affiliate.id
    end
  end

  describe '#affiliates' do
    it 'fetches affiliates and returns a hash of affiliate instances' do
      affiliates = Tapfiliate.affiliates
      assert_instance_of Tapfiliate::Affiliate, affiliates.first
    end
  end

  describe '#create_affiliate' do
    it 'creates and instantiates the affiliate' do
      affiliate = Tapfiliate.create_affiliate(
        firstname: ENV['TEST_AFFILIATE_NAME'],
        lastname: ENV['TEST_AFFILIATE_LAST_NAME'],
        email: ENV['TEST_NEW_AFFILIATE_EMAIL']
      )
      assert affiliate.id
      assert_instance_of Tapfiliate::Affiliate, affiliate
    end
  end
end

# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'tapfiliate'

require 'minitest/autorun'
require 'dotenv'
require 'webmock'
require 'webmock/minitest'

Dotenv.load('.env')
Dotenv.load('.env.test')

Tapfiliate.configure do |config|
  config.base_url = ENV['TAPFILIATE_API_BASE_URL']
  config.api_key = ENV['TAPFILIATE_API_KEY']
end

WebMock.allow_net_connect!

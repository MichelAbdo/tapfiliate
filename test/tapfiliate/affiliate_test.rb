# frozen_string_literal: true

require 'test_helper'

class AffiliateTest < Minitest::Test
  affiliate_id = ENV['TEST_AFFILIATE_ID']
  describe '#fetch' do
    it 'fetches a affiliate by id and instantiates it' do
      affiliate = Tapfiliate::Affiliate.fetch(id: affiliate_id)
      assert_instance_of Tapfiliate::Affiliate, affiliate
      assert_equal affiliate_id, affiliate.id
    end

    it 'returns nil when the affiliate is not found' do
      response = Tapfiliate::Affiliate.fetch(id: 'some-affiliate')
      assert_nil response
    end
  end

  describe '#fetch_all' do
    it 'fetches affiliates and returns a hash of affiliate instances' do
      affiliates = Tapfiliate::Affiliate.fetch_all
      assert_instance_of Tapfiliate::Affiliate, affiliates.first
    end

    it 'filters affiliates and returns a hash of affiliate instances' do
      affiliate_email = ENV['TEST_AFFILIATE_EMAIL']
      affiliates = Tapfiliate::Affiliate.fetch_all(email: affiliate_email)
      affiliate = affiliates.first
      assert_instance_of Tapfiliate::Affiliate, affiliate
      assert affiliate.id
      assert_equal affiliate.email, affiliate_email
    end

    it 'returns an empty hash when the conversions collection is empty' do
      conversions = Tapfiliate::Conversion.fetch_all(program_id: 'some-program')
      assert_empty conversions
    end
  end

  describe '#initialize' do
    it 'creates a affiliate object from a given set of arguments' do
      args = { id: 1, firstname: 'abc', lastname: 'def' }
      affiliate = Tapfiliate::Affiliate.new(args)
      assert affiliate
      assert affiliate.id
      assert_equal args[:id], affiliate.id
    end
  end

  describe '#create' do
    it 'creates and instantiates the affiliate' do
      affiliate = Tapfiliate::Affiliate.create(
        firstname: ENV['TEST_AFFILIATE_NAME'],
        lastname: ENV['TEST_AFFILIATE_LAST_NAME'],
        email: ENV['TEST_NEW_AFFILIATE_EMAIL']
      )
      assert affiliate.id
      assert_instance_of Tapfiliate::Affiliate, affiliate
    end

    it 'returns a 400 error if the affiliate already exists' do
      assert_raises(Tapfiliate::Error) do
        Tapfiliate.create_affiliate(
          firstname: ENV['TEST_AFFILIATE_NAME'],
          lastname: ENV['TEST_AFFILIATE_LAST_NAME'],
          email: ENV['TEST_AFFILIATE_EMAIL']
        )
      end
    end
  end
end

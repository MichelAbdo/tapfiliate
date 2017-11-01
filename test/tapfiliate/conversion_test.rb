# frozen_string_literal: true

require 'test_helper'

class ConversionTest < Minitest::Test
  conversion_id = ENV['TEST_CONVERSION_ID'].to_i
  describe '#fetch' do
    it 'fetches a conversion by id and instantiates the fetched conversion' do
      conversion = Tapfiliate::Conversion.fetch(id: conversion_id)
      assert_instance_of Tapfiliate::Conversion, conversion
      assert_equal conversion_id, conversion.id
    end

    it 'returns nil when the conversion is not found' do
      response = Tapfiliate::Conversion.fetch(id: 111)
      assert_nil response
    end
  end

  describe '#fetch_all' do
    it 'fetches conversions and returns a hash of conversion instances' do
      conversions = Tapfiliate::Conversion.fetch_all
      assert_instance_of Tapfiliate::Conversion, conversions.first
    end

    it 'returns an empty hash when the conversions collection is empty' do
      conversions = Tapfiliate::Conversion.fetch_all(program_id: 'some-program')
      assert_empty conversions
    end
  end

  describe '#initialize' do
    it 'creates a conversion object from a given set of arguments' do
      args = { id: 1, external_id: 'abc', amount: 123, commissions: {} }
      conversion = Tapfiliate::Conversion.new(args)
      assert conversion
      assert conversion.id
      assert_equal args[:id], conversion.id
    end
  end

  describe '#commissions' do
    it 'instantiates the conversion commissions' do
      conversion = Tapfiliate::Conversion.fetch(id: conversion_id)
      assert conversion.commissions
      assert conversion.commissions.first
      assert conversion.commissions.first.id
      assert_instance_of Tapfiliate::Commission, conversion.commissions.first
    end
  end

  describe '#program' do
    it 'instantiates the conversion program' do
      conversion = Tapfiliate::Conversion.fetch(id: conversion_id)
      assert conversion.program
      assert conversion.program.id
      assert_instance_of Tapfiliate::Program, conversion.program
    end
  end

  describe '#program' do
    it 'instantiates the conversion affiliate' do
      conversion = Tapfiliate::Conversion.fetch(id: conversion_id)
      assert conversion.affiliate
      assert conversion.affiliate.id
      assert_instance_of Tapfiliate::Affiliate, conversion.affiliate
    end
  end

  describe '#meta_data' do
    it 'raises an error if the conversion metadata is not a hash' do
      meta_data_exception = assert_raises(Tapfiliate::InvalidArgumentsError) do
        conversion = Tapfiliate::Conversion.fetch(id: conversion_id)
        conversion.meta_data = 1
      end
      assert_equal 'Metadata must be a hash', meta_data_exception.message
    end
  end

  describe '#save' do
    it 'Updates the conversion attributes on save' do
      new_amount = rand(0..10)
      new_meta_value = %w[One Two Three Four Five].sample
      conversion = Tapfiliate::Conversion.fetch(id: conversion_id)
      conversion.amount = new_amount
      conversion.meta_data['test'] = new_meta_value
      updated_conversion = conversion.save
      assert_equal updated_conversion.amount, new_amount
      assert_equal updated_conversion.meta_data['test'], new_meta_value
    end
  end
end

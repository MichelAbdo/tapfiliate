# frozen_string_literal: true

require 'test_helper'

class CommissionTest < Minitest::Test
  conversion_id = ENV['TEST_CONVERSION_ID'].to_i
  describe '#initialize' do
    it 'creates a commission object from a given set of arguments' do
      args = { id: 1, kind: 'abc', amount: 123, payout: {}, affiliate: {} }
      commission = Tapfiliate::Commission.new(args)
      assert commission
      assert commission.id
      assert_equal args[:id], commission.id
    end
  end

  describe '#save' do
    it 'Updates the commission attributes on save' do
      new_amount = rand(0..10)
      new_comment = %w[One Two Three Four Five].sample
      conversion = Tapfiliate::Conversion.fetch(id: conversion_id)
      commission = conversion.commissions.first
      commission.amount = new_amount
      commission.comment = new_comment
      updated_commission = commission.save
      assert_equal updated_commission.amount, new_amount
      assert_equal updated_commission.comment, new_comment
    end
  end
end

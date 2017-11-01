# frozen_string_literal: true

require 'test_helper'

class ProgramTest < Minitest::Test
  program_id = ENV['TEST_PROGRAM_ID']
  describe '#fetch' do
    it 'fetches a program by id and instantiates it' do
      program = Tapfiliate::Program.fetch(id: program_id)
      assert_instance_of Tapfiliate::Program, program
      assert_equal program_id, program.id
    end

    it 'returns nil when the program is not found' do
      response = Tapfiliate::Program.fetch(id: 'some-program')
      assert_nil response
    end
  end

  describe '#fetch_all' do
    it 'fetches programs and returns a hash of program instances' do
      programs = Tapfiliate::Program.fetch_all
      assert_instance_of Tapfiliate::Program, programs.first
    end
  end

  describe '#initialize' do
    it 'creates a program object from a given set of arguments' do
      args = { id: 1, title: 'abc', currency: 'USD' }
      program = Tapfiliate::Program.new(args)
      assert program
      assert program.id
      assert_equal args[:id], program.id
    end
  end

  describe '#affiliates' do
    it 'gets and sets the program \'s affiliates' do
      program = Tapfiliate::Program.fetch(id: program_id)
      program_affiliates = program.affiliates
      assert program_affiliates
      assert_instance_of Tapfiliate::Affiliate, program_affiliates.first
      assert program_affiliates.first.id
    end
  end

  describe '#add_affiliate' do
    it 'raises a argument error if the affiliate is not an affiliate object' do
      program = Tapfiliate::Program.fetch(id: program_id)
      exception = assert_raises(Tapfiliate::InvalidArgumentsError) do
        program.add_affiliate(affiliate: 1, approved: true)
      end
      assert_equal 'Affiliate must be an instance of the affiliate class',
                   exception.message
    end

    it 'adds an affiliate to the program' do
      program = Tapfiliate::Program.fetch(id: program_id)
      affiliate = Tapfiliate.create_affiliate(
        firstname: ENV['TEST_AFFILIATE_NAME'],
        lastname: ENV['TEST_AFFILIATE_LAST_NAME'],
        email: ENV['TEST_AFFILIATE_EMAIL']
      )
      response = program.add_affiliate(affiliate: affiliate, approved: true)
      assert response[:referral_link]
    end

    it 'returns a 400 error if the affiliate is already member of program' do
      program = Tapfiliate::Program.fetch(id: program_id)
      affiliate = Tapfiliate.affiliate(id: ENV['TEST_AFFILIATE_ID'])
      assert_raises(Tapfiliate::Error) do
        program.add_affiliate(affiliate: affiliate, approved: true)
      end
    end
  end
end

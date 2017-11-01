# frozen_string_literal: true

module Tapfiliate
  # Tapfiliate conversion
  class Conversion
    attr_writer :amount, :meta_data

    WHITELIST = %w[
      program_id
      external_id
      affiliate_id
      pending
      date_from
      date_to
    ].freeze

    class << self
      def attrs
        %i[
          affiliate
          amount
          click
          commissions
          created_at
          external_id
          id
          meta_data
          program
        ].freeze
      end

      def fetch(id:)
        response = Tapfiliate.request(
          uri: Tapfiliate.endpoint(:conversion, id: id),
          http_method: 'get'
        )
        return nil if response.nil?
        new(response)
      end

      def fetch_all(**args)
        filtered_args = args.select { |key, _| WHITELIST.include? key.to_s }
        response = Tapfiliate.request(
          uri: Tapfiliate.endpoint(:conversions, query: filtered_args),
          http_method: 'get'
        )
        return {} if response.nil?
        response.map { |json_attrs| new(json_attrs) }
      end
    end

    attr_reader(*attrs)

    def initialize(**args)
      args.each do |k, v|
        instance_variable_set("@#{k}", v) if self.class.attrs.include?(k)
      end
    end

    def commissions
      @commissions.map { |commission| Commission.new(commission) }
    end

    def meta_data=(meta_data)
      raise Tapfiliate::InvalidArgumentsError, 'Metadata must be a hash' unless meta_data.is_a? Hash
      @meta_data = meta_data
    end

    def save
      Tapfiliate.request(
        uri: Tapfiliate.endpoint(:conversion, id: @id),
        http_method: 'patch',
        data_params: { amount: @amount, meta_data: @meta_data }
      )
      self
    end

    def program
      Program.new(@program)
    end

    def affiliate
      Affiliate.new(@affiliate)
    end
  end
end

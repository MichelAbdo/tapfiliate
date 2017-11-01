# frozen_string_literal: true

module Tapfiliate
  # Tapfiliate program
  class Program
    attr_accessor :affiliates

    class << self
      def attrs
        %i[
          cookie_time
          currency
          default_landing_page_url
          id
          title
        ].freeze
      end

      def fetch(id:)
        response = Tapfiliate.request(
          uri: Tapfiliate.endpoint(:program, id: id),
          http_method: 'get'
        )
        return nil if response.nil?
        new(response)
      end

      def fetch_all
        response = Tapfiliate.request(
          uri: Tapfiliate.endpoint(:programs),
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

    def affiliates
      response = Tapfiliate.request(
        uri: Tapfiliate.endpoint(:program_affiliates, id: @id),
        http_method: 'get'
      )
      return {} if response.nil?
      response.map { |json_attrs| Affiliate.new(json_attrs) }
    end

    def add_affiliate(affiliate:, approved: false)
      raise Tapfiliate::InvalidArgumentsError, 'Affiliate must be an instance of the affiliate class' unless affiliate.is_a?(Tapfiliate::Affiliate)
      response = Tapfiliate.request(
        uri: Tapfiliate.endpoint(:program_affiliates, id: @id),
        http_method: 'post',
        data_params: { affiliate: { id: affiliate.id.to_s }, approved: approved }
      )
      return nil if response.nil?
      response
    end
  end
end

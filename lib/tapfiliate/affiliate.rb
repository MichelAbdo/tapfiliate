# frozen_string_literal: true

module Tapfiliate
  # Tapfiliate affiliate
  class Affiliate
    attr_accessor :affiliates

    WHITELIST = %w[click_id source_id email].freeze

    class << self
      def attrs
        %i[
          address
          company
          email
          firstname
          id
          lastname
          meta_data
          parent_id
          password
          referral_link
          coupon
          approved
        ].freeze
      end

      def create(firstname:, lastname:, email:, password: nil, company: {})
        response = Tapfiliate.request(
          uri: Tapfiliate.endpoint(:create_affiliate),
          http_method: 'post',
          data_params: { firstname: firstname, lastname: lastname, email: email,
                         password: password, company: company }
        )
        return nil if response.nil?
        new(response)
      end

      def fetch(id:)
        response = Tapfiliate.request(
          uri: Tapfiliate.endpoint(:affiliate, id: id),
          http_method: 'get'
        )
        return nil if response.nil?
        new(response)
      end

      def fetch_all(**args)
        filtered_args = args.select { |key, _| WHITELIST.include? key.to_s }
        response = Tapfiliate.request(
          uri: Tapfiliate.endpoint(:affiliates, query: filtered_args),
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
  end
end

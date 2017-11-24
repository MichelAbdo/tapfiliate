# frozen_string_literal: true

module Tapfiliate
  # Tapfiliate commission
  class Commission
    attr_writer :amount, :comment

    class << self
      def attrs
        %i[
          affiliate
          amount
          approved
          comment
          commission_type
          conversion_sub_amount
          conversion
          created_at
          id
          kind
          payout
        ].freeze
      end
    end

    attr_reader(*attrs)

    def initialize(**args)
      args.each do |k, v|
        instance_variable_set("@#{k}", v) if self.class.attrs.include?(k)
      end
    end

    def save
      Tapfiliate.request(
        uri: Tapfiliate.endpoint(:save_commission, id: @id),
        http_method: 'patch',
        data_params: { amount: @amount, comment: @comment }
      )
      self
    end
  end
end

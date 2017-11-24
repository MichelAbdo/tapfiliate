# frozen_string_literal: true

module Tapfiliate
  ENDPOINTS = {
    conversion: '/conversions/{id}/',
    conversions: '/conversions/{?query*}',
    save_commission: '/commissions/{id}/',
    create_affiliate: '/affiliates/',
    affiliate: '/affiliates/{id}/',
    affiliates: '/affiliates/{?query*}',
    program: '/programs/{id}/',
    programs: '/programs/',
    program_affiliates: '/programs/{id}/affiliates/'
  }.freeze
end

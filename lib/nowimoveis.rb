# frozen_string_literal: true

require_relative 'nowimoveis/version'
require 'f1sales_custom/parser'
require 'f1sales_custom/source'
require 'f1sales_custom/hooks'
require 'byebug'

module Nowimoveis
  class Error < StandardError; end

  class F1SalesCustom::Hooks::Lead
    def self.switch_source(lead)
      source_name = lead.source.name
      product_name_down = lead.product.name.downcase
      return source_name unless source_name.downcase['facebook']

      if product_name_down['prospectores']
        "#{source_name} - Prospectores"
      elsif product_name_down['corretores']
        "#{source_name} - Corretores"
      else
        source_name
      end
    end
  end
end

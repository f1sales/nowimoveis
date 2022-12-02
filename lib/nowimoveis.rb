# frozen_string_literal: true

require_relative 'nowimoveis/version'
require 'f1sales_custom/parser'
require 'f1sales_custom/source'
require 'f1sales_custom/hooks'
require 'f1sales_helpers'

module Nowimoveis
  class Error < StandardError; end

  class F1SalesCustom::Email::Source
    def self.all
      [
        {
          email_id: 'website',
          name: 'Website'
        }
      ]
    end
  end

  class F1SalesCustom::Email::Parser
    def parse
      email_lead
    end

    def parsed_email
      @email.body.colons_to_hash(/(Nome|Telefone|Email|Produto|Date).*?:/, false)
    end

    def email_lead
      {
        source: source_name,
        customer: customer,
        product: product
      }
    end

    def source_name
      {
        name: F1SalesCustom::Email::Source.all[0][:name]
      }
    end

    def customer
      {
        name: parsed_email['nome'],
        phone: parsed_email['telefone'],
        email: parsed_email['email']
      }
    end

    def product
      {
        name: parsed_email['produto'].split("\n").first.strip
      }
    end
  end

  class F1SalesCustom::Hooks::Lead
    def self.switch_source(lead)
      source_name = lead.source.name
      product_name_down = lead.product.name.downcase
      return source_name unless source_name.downcase['facebook']

      if product_name_down['prospectores']
        "#{source_name} - Prospectores"
      elsif product_name_down['corretores']
        "#{source_name} - Corretores"
      elsif product_name_down['marina']
        "#{source_name} - Marina"
      else
        source_name
      end
    end
  end
end

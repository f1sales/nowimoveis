require 'ostruct'

RSpec.describe F1SalesCustom::Hooks::Lead do
  context 'when lead come form Facebook' do
    let(:lead) do
      lead = OpenStruct.new
      lead.source = source
      lead.product = product

      lead
    end

    let(:source) do
      source = OpenStruct.new
      source.name = 'Facebook'

      source
    end

    let(:product) do
      product = OpenStruct.new
      product.name = ''

      product
    end

    let(:switch_source) { described_class.switch_source(lead) }

    context 'when the product is neither Prospectores nor Corretores' do
      it 'return source Facebook' do
        expect(switch_source).to eq('Facebook')
      end
    end

    context 'when the product contains Prospectores' do
      before { product.name = '[Prospectores] - Torino - Novo' }

      it 'return source Facebook - Prospectores' do
        expect(switch_source).to eq('Facebook - Prospectores')
      end
    end
  end
end

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

    context 'when the product contains Corretores' do
      before { product.name = '[Corretores] - Torino - Novo' }

      it 'return source Facebook - Corretores' do
        expect(switch_source).to eq('Facebook - Corretores')
      end
    end

    context 'when the product contains Marina' do
      before { product.name = '[Marina] - Mozart' }

      it 'return source Facebook - Corretores' do
        expect(switch_source).to eq('Facebook - Marina')
      end
    end
  end

  context 'when is from another source' do
    let(:lead) do
      lead = OpenStruct.new
      lead.source = source
      lead.product = product

      lead
    end

    let(:source) do
      source = OpenStruct.new
      source.name = 'Another source'

      source
    end

    let(:product) do
      product = OpenStruct.new
      product.name = ''

      product
    end

    let(:switch_source) { described_class.switch_source(lead) }

    it 'returns source name' do
      expect(switch_source).to eq('Another source')
    end
  end
end

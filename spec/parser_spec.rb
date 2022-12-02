require 'ostruct'
require 'f1sales_custom/parser'
require 'f1sales_custom/source'

RSpec.describe F1SalesCustom::Email::Parser do
  context 'when is from website to SBC' do
    let(:email) do
      email = OpenStruct.new
      email.to = [{:token=>"website", :host=>"nowimoveis.f1sales.net", :email=>"website@nowimoveis.f1sales.net", :full=>"website@nowimoveis.f1sales.net", :name=>nil}, {:token=>"nowimoveis+jplgb1gprpmcur4acdl2", :host=>"boards.trello.com", :email=>"nowimoveis+jplgb1gprpmcur4acdl2@boards.trello.com", :full=>"nowimoveis+jplgb1gprpmcur4acdl2@boards.trello.com", :name=>nil}]
      email.subject = 'Lead teste'
      email.body = "Nome: Lead teste \nEmail: teste@torinoresidencial.com.br \nTelefone: 11902121219 \nProduto: Torino \n\n--- \n\nDate: 02/12/2022 \nTime: 12:19"

      email
    end

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains lead website a source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[0][:name])
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Lead teste')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('teste@torinoresidencial.com.br')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('11902121219')
    end

    it 'contains product' do
      expect(parsed_email[:product][:name]).to eq('Torino')
    end
  end
end

require 'spec_helper'
require_relative '../services/txt_output_service'
# require_relative '../data_models/user'

RSpec.describe TxtOutputService do
  describe 'append_company_data_to_output_file' do
    let(:company) { double(id: 7, name: 'Test Company Inc.') }
    let(:expected_data) do
      <<~EXPECTED
        Company Id: 7
        Company Name: Test Company Inc.
      EXPECTED
    end

    it 'should write expected data' do
      expect(TxtOutputService).to receive(:write_new_line_to_output_file).with(expected_data)
      TxtOutputService.send(:append_company_data_to_output_file, company)
    end
  end

  describe 'append_user_data_to_output_file' do
    let(:user) { User.new(raw_hash: {'first_name'=>'Jon', 'last_name'=>'Doe', 'email'=>'doe.jon@test.it', 'tokens'=>4}, company: nil) }
    before{ allow(user).to receive(:new_token_balance).and_return(23) }
    let(:expected_data) do
      <<~EXPECTED
        \tDoe, Jon, doe.jon@test.it
        \t\tPrevious Token Balance, 4
        \t\tNew Token Balance 23
      EXPECTED
    end

    it 'should write expected data' do
      expect(TxtOutputService).to receive(:write_new_line_to_output_file).with(expected_data)
      TxtOutputService.send(:append_user_data_to_output_file, user)
    end
  end
end

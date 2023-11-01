require 'spec_helper'
require_relative '../data_models/user'
require_relative '../data_models/company'

RSpec.describe User do
  let(:tokens) { 1 }
  let(:company_id) { 1 }
  let(:active_status) { true }
  let(:top_up) { 1 }
  let(:user_email_status) { true }
  let(:company_email_status) { true }
  let(:user_hash) { { 'email_status' => user_email_status, 'tokens' => tokens, 'company_id' => company_id, 'active_status' => active_status }}
  let(:company) { double('id' => company_id, 'top_up' => top_up, 'email_status' => company_email_status) }
  let(:user) { User.new(raw_hash: user_hash, company: company) }

  describe '#can_receive_email?' do
    shared_examples 'not able to receive email' do
      it 'return false' do
        expect(user.can_receive_email?).to be_falsey
      end
    end

    shared_examples 'user is able to receive email' do
      it 'returns true' do
        expect(user.can_receive_email?).to be_truthy
      end
    end

    context 'company email_status is false' do
      let(:company_email_status) { false }

      context 'user email status is true' do
        let(:user_email_status) { true }
        it_behaves_like 'not able to receive email'
      end

      context 'user email status is false' do
        let(:user_email_status) { false }
        it_behaves_like 'not able to receive email'
      end
    end

    context 'company email_status is true' do
      let(:company_email_status) { true }

      context 'user email status is true' do
        let(:user_email_status) { true }
        it_behaves_like 'user is able to receive email'
      end

      context 'user email status is false' do
        let(:user_email_status) { false }
        it_behaves_like 'not able to receive email'
      end
    end

    context 'no company associated' do
      let(:company) { nil }
      context 'user email status is true' do
        let(:user_email_status) { true }
        it_behaves_like 'not able to receive email'
      end

      context 'user email status is false' do
        let(:user_email_status) { false }
        it_behaves_like 'not able to receive email'
      end
    end
  end

  describe '#can_get_token_top_up?' do
    shared_examples 'not able to get a top up' do
      it 'return false' do
        expect(user.send(:can_get_token_top_up?)).to be_falsey
      end
    end

    shared_examples 'user is able to get a top up' do
      it 'returns true' do
        expect(user.send(:can_get_token_top_up?)).to be_truthy
      end
    end

    context 'user has no company' do
      let(:company) { nil }

      context 'user is active' do
        let(:active_status) { true }
        it_behaves_like 'not able to get a top up'
      end

      context 'user is inactive' do
        let(:active_status) { false }
        it_behaves_like 'not able to get a top up'
      end
    end

    context 'user belongs to a company' do
      context 'user is active' do
        let(:active_status) { true }
        it_behaves_like 'user is able to get a top up'
      end

      context 'user is inactive' do
        let(:active_status) { false }
        it_behaves_like 'not able to get a top up'
      end
    end
  end

  describe '#new_token_balance' do
    context 'when can not get token top up' do
      before{ allow(user).to receive(:can_get_token_top_up?).and_return(false) }
      it 'should return just user token without adding company top up' do
        expect(user.new_token_balance).to eq(1)
      end
    end

    context 'when can_get_token_top_up' do
      before{ allow(user).to receive(:can_get_token_top_up?).and_return(true) }
      it 'should return a sum of user token and company top up' do
        expect(user.new_token_balance).to eq(2)
      end
    end
  end
end

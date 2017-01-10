require 'rails_helper'

describe Admin::StaffMembersController do
  context 'ログイン前' do
    it_behaves_like 'a protected admin controller'
  end
end

describe Admin::StaffMembersController do
  let(:params_hash) { attributes_for(:staff_member) }
  let(:administrator) { create(:administrator) }
  before do
    session[:administrator_id] = administrator.id
    session[:last_access_time] = 1.second.ago
  end

  describe '#create' do
    example '職員一覧ページにリダイレクト' do
      post :create, staff_member: params_hash
      expect(response).to redirect_to admin_staff_members_url
    end

    example '例外ActionController::ParameterMissingが発生' do
      bypass_rescue
      expect { post :create }.
        to raise_error(ActionController::ParameterMissing)
    end
  end

  describe '#update' do
    let(:staff_member) { create(:staff_member) }

    example 'suspendedフラグをセットする' do
      params_hash.merge!(suspended: true)
      patch :update, id: staff_member.id, staff_member: params_hash
      staff_member.reload
      expect(staff_member).to be_suspended
    end

    example 'hashed_passwordの値は更新できない' do
      params_hash.delete(:password)
      params_hash.merge!(hashed_password: 'hoge')
      expect do
        patch :update, id: staff_member.id, staff_member: params_hash
      end.not_to change { staff_member.hashed_password.to_s }
    end
  end
end
require 'rails_helper'

describe Admin::Authenticator do
  describe '#authenticate' do
    let(:attributes) { {} }
    let(:administrator) { build(:administrator, attributes) }

    example 'パスワードが正しければtrueを返す' do
      expect(Admin::Authenticator.new(administrator).authenticate('pw')).to be_truthy
    end

    example 'パスワードが間違っていればfalseを返す' do
      expect(Admin::Authenticator.new(administrator).authenticate('pwxx')).to be_falsey
    end

    example 'パスワードがnilならばfalseを返す' do
      expect(Admin::Authenticator.new(administrator).authenticate(nil)).to be_falsey
    end

    example '停止フラグが立っていてもtrueを返す' do
      attributes.merge!(suspended: true)
      expect(Admin::Authenticator.new(administrator).authenticate('pw')).to be_truthy
    end
  end
end

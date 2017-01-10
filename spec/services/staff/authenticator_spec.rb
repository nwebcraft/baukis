require 'rails_helper'

describe Staff::Authenticator do
  describe '#authenticate' do
    let(:attributes) { {} }
    let(:staff_member) { build(:staff_member, attributes) }

    example 'パスワードが正しければtrueを返す' do
      expect(Staff::Authenticator.new(staff_member).authenticate('pw')).to be_truthy
    end

    example 'パスワードが間違っていればfalseを返す' do
      expect(Staff::Authenticator.new(staff_member).authenticate('pwxx')).to be_falsey
    end

    example 'パスワードがnilならばfalseを返す' do
      expect(Staff::Authenticator.new(staff_member).authenticate(nil)).to be_falsey
    end

    example '停止フラグが立っていてもtrueを返す' do
      attributes.merge!(suspended: true)
      expect(Staff::Authenticator.new(staff_member).authenticate('pw')).to be_truthy
    end

    example '開始前ならばfalseを返す' do
      attributes.merge!(start_date: Date.tomorrow)
      expect(Staff::Authenticator.new(staff_member).authenticate('pw')).to be_falsey
    end

    example '終了後ならばfalseを返す' do
      attributes.merge!(end_date: Date.yesterday)
      expect(Staff::Authenticator.new(staff_member).authenticate('pw')).to be_falsey
    end
  end
end

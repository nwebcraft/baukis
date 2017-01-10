require 'rails_helper'

RSpec.describe StaffMember, :type => :model do
  describe '#password=' do
    example '文字列を与えると、hashed_passwordは長さ60の文字列になる' do
      member = StaffMember.new
      member.password = 'baukis'
      expect(member.hashed_password).to be_kind_of String
      expect(member.hashed_password.length).to eq 60
    end

    example 'nilを与えると、hashed_passwordはnilになる' do
      member = StaffMember.new(hashed_password: 'xyz')
      member.password = nil
      expect(member.hashed_password).to be_nil
    end
  end

  describe '値の正規化' do
    example 'email前後の空白の除去' do
      member = build(:staff_member, email: ' test@example.com ')
      member.valid?
      expect(member.email).to eq 'test@example.com'
    end

    example 'emailに含まれる全角英数字記号を半角に変換' do
      member = build(:staff_member, email: 'ｔｅｓｔ＠ｅｘａｍｐｌｅ１．ｃｏｍ')
      member.valid?
      expect(member.email).to eq 'test@example1.com'
    end

    example 'email前後の全角スペースを除去' do
      member = build(:staff_member, email: "　test@example.com\u{3000}")
      member.valid?
      expect(member.email).to eq 'test@example.com'
    end

    example 'family_name_kanaに含まれるひらがなをカタカナに変換' do
      member = build(:staff_member, family_name_kana: 'にしじま')
      member.valid?
      expect(member.family_name_kana).to eq 'ニシジマ'
    end

    example 'family_name_kanaに含まれる半角カタカナを全角カタカナに変換' do
      member = build(:staff_member, family_name_kana: 'ﾆｼｼﾞﾏ')
      member.valid?
      expect(member.family_name_kana).to eq 'ニシジマ'
    end
  end

  describe 'バリデーション' do
    example 'emailに@が２個含まれる場合はエラー' do
      member = build(:staff_member, email: 'test@@example.com')
      expect(member).not_to be_valid
    end

    example 'family_nameに記号が含まれる場合はエラー' do
      member = build(:staff_member, family_name: '西島！#')
      expect(member).not_to be_valid
    end

    example 'family_name_kanaに漢字が含まれる場合はエラー' do
      member = build(:staff_member, family_name_kana: '西島')
      expect(member).not_to be_valid
    end

    example 'family_name_kanaに長音符が含まれる場合はエラーにならない' do
      member = build(:staff_member, family_name_kana: 'ニシジーマ')
      expect(member).to be_valid
    end

    example '他の職員のメールアドレスと重複した場合はエラー' do
      member1 = create(:staff_member, email: 'test@example.com')
      member2 = build(:staff_member, email: 'Test@Example.COM')
      member2.valid?
      expect(member2).not_to be_valid
    end
  end
end

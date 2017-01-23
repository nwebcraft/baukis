require 'rails_helper'

feature '職員による自分のアカウント管理' do
  include FeaturesSpecHelper

  given(:staff_member) { create(:staff_member) }

  background :each do
    switch_namespace(:staff)
    login_as_staff_member(staff_member)
    click_link 'アカウント'
    click_link 'アカウント情報編集'
  end

  scenario '職員がメールアドレスと氏名を更新する' do
    fill_in 'メールアドレス', with: 'koike@yurikoO.com'
    fill_in 'staff_member_family_name', with: '小池'
    fill_in 'staff_member_given_name', with: '百合子'
    fill_in 'staff_member_family_name_kana', with: 'こいけ'
    fill_in 'staff_member_given_name_kana', with: 'ゆりこ'
    click_button '確認する'
    click_button '訂正'
    fill_in 'メールアドレス', with: 'koike@YURIKO.com'
    click_button '確認する'
    click_button '更新'

    staff_member.reload
    expect(staff_member.email).to eq 'koike@YURIKO.com'
    expect(staff_member.family_name).to eq '小池'
    expect(staff_member.given_name).to eq '百合子'
    expect(staff_member.family_name_kana).to eq 'コイケ'
    expect(staff_member.given_name_kana).to eq 'ユリコ'
  end
end

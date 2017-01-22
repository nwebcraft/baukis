require 'rails_helper'

feature '顧客によるアカウント管理' do
  include FeatureSpecHelper

  given(:customer) { create(:customer) }

  background :each do
    switch_namespace(:customer)
    login_as_customer(customer)
    click_link 'アカウント'
    click_link '編集'
  end

  scenario '顧客が基本情報、自宅住所、勤務先を更新する' do
    within('fieldset#customer-fields') do
      fill_in 'メールアドレス', with: 'songoku@dragon.ball'
      fill_in 'form_customer_family_name', with: '孫'
      fill_in 'form_customer_given_name', with: '悟空'
      fill_in 'form_customer_family_name_kana', with: 'そん'
      fill_in 'form_customer_given_name_kana', with: 'ゴクウ'
      fill_in '生年月日', with: '2001-04-01'
      fill_in 'form_customer_phones_0_number', with: '0311112222'
      check 'form_customer_phones_0_primary'
      fill_in 'form_customer_phones_1_number', with: '0755001234'
    end
    within('fieldset#home-address-fields') do
      fill_in '郵便番号', with: '1234567'
      fill_in 'form_home_address_phones_0_number', with: '0698761234'
    end
    click_button '確認する'
    click_button '訂正'

    end
  end
end

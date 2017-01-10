require 'rails_helper'

feature '職員による顧客電話番号管理' do
  include FeatureSpecHelper

  given(:staff_member) { create(:staff_member) }
  given!(:customer1) do
    create(:customer,
      family_name: '西島',
      family_name_kana: 'ニシジマ'
    )
  end
  given!(:customer2) do
    create(:customer,
      family_name: '伊藤',
      family_name_kana: 'イトウ'
    )
  end
  given!(:customer3) do
    create(:customer,
      family_name: '山口',
      family_name_kana: 'ヤマグチ'
    )
  end

  background :each do
    switch_namespace(:staff)
    login_as_staff_member(staff_member)
  end

  scenario '職員が顧客の電話番号を追加する' do
    click_link '顧客管理'
    all('table.listing > tr')[2].click_link '編集'

    fill_in 'form_customer_phones_0_number', with: '080-2091-3472'
    check 'form_customer_phones_0_primary'
    fill_in 'form_customer_phones_1_number', with: '042-667-2471'

    click_on '更新'

    customer1.reload
    expect(customer1.phones.size).to eq 2
    expect(customer1.personal_phones.size).to eq 2
    expect(customer1.personal_phones[0].number).to eq '080-2091-3472'
    expect(customer1.personal_phones[0]).to be_primary
    expect(customer1.personal_phones[1].number).to eq '042-667-2471'
    expect(customer1.personal_phones[1]).not_to be_primary
  end

  scenario '職員が顧客の自宅電話番号を追加する' do
    click_link '顧客管理'
    all('table.listing > tr')[2].click_link '編集'

    fill_in 'form_home_address_phones_0_number', with: '080-2091-3472'
    check 'form_home_address_phones_0_primary'
    fill_in 'form_home_address_phones_1_number', with: '042-667-2471'

    click_on '更新'

    customer1.reload
    expect(customer1.phones.size).to eq 2
    expect(customer1.personal_phones.size).to eq 0
    expect(customer1.home_address.phones.size).to eq 2
    expect(customer1.work_address.phones.size).to eq 0
    expect(customer1.home_address.phones[0].number).to eq '080-2091-3472'
    expect(customer1.home_address.phones[0]).to be_primary
    expect(customer1.home_address.phones[1].number).to eq '042-667-2471'
    expect(customer1.home_address.phones[1]).not_to be_primary
  end

  scenario '職員が顧客の勤務先電話番号を追加する' do
    click_link '顧客管理'
    all('table.listing > tr')[2].click_link '編集'

    fill_in 'form_work_address_phones_0_number', with: '080-2091-3472'
    check 'form_work_address_phones_0_primary'
    fill_in 'form_work_address_phones_1_number', with: '042-667-2471'

    click_on '更新'

    customer1.reload
    expect(customer1.phones.size).to eq 2
    expect(customer1.personal_phones.size).to eq 0
    expect(customer1.home_address.phones.size).to eq 0
    expect(customer1.work_address.phones.size).to eq 2
    expect(customer1.work_address.phones[0].number).to eq '080-2091-3472'
    expect(customer1.work_address.phones[0]).to be_primary
    expect(customer1.work_address.phones[1].number).to eq '042-667-2471'
    expect(customer1.work_address.phones[1]).not_to be_primary
  end
end

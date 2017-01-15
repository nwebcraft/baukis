require 'rails_helper'

feature '職員による顧客管理' do
  include FeaturesSpecHelper

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

  scenario '職員が顧客を登録する' do
    click_link '顧客管理'
    first('div.links').click_link '新規登録'

    within('fieldset#customer-fields') do
      fill_in 'メールアドレス', with: 'makoto.nishijima@example.com'
      fill_in 'パスワード', with: 'password'
      fill_in 'form_customer_family_name', with: '西島'
      fill_in 'form_customer_given_name', with: '誠'
      fill_in 'form_customer_family_name_kana', with: 'ニシジマ'
      fill_in 'form_customer_given_name_kana', with: 'マコト'
      fill_in '生年月日', with: '1975-03-01'
      choose '男性'
    end
    check '自宅住所を入力する'
    within('fieldset#home-address-fields') do
      fill_in '郵便番号', with: '1930831'
      select '東京都', from: '都道府県'
      fill_in '市区町村', with: '八王子市'
      fill_in '町域、番地等', with: '並木町5-1-207'
      fill_in '建物名、部屋番号等', with: ''
    end
    check '勤務先を入力する'
    within('fieldset#work-address-fields') do
      fill_in '会社名', with: 'プレセナ'
      fill_in '部署名', with: ''
      fill_in '郵便番号', with: ''
      select '東京都', from: '都道府県'
      fill_in '市区町村', with: '千代田区'
      fill_in '町域、番地等', with: ''
      fill_in '建物名、部屋番号等', with: ''
    end

    click_on '登録'

    new_customer = Customer.order(:id).last
    expect(new_customer.email).to eq 'makoto.nishijima@example.com'
    expect(new_customer.family_name).to eq '西島'
    expect(new_customer.given_name_kana).to eq 'マコト'
    expect(new_customer.birthday).to eq Date.new(1975, 3, 1)
    expect(new_customer.gender).to eq 'male'
    expect(new_customer.home_address.postal_code).to eq '1930831'
    expect(new_customer.work_address.company_name).to eq 'プレセナ'
  end

  scenario '職員が顧客の基本情報のみ登録する' do
    click_link '顧客管理'
    first('div.links').click_link '新規登録'

    within('fieldset#customer-fields') do
      fill_in 'メールアドレス', with: 'makoto.nishijima@example.com'
      fill_in 'パスワード', with: 'password'
      fill_in 'form_customer_family_name', with: '西島'
      fill_in 'form_customer_given_name', with: '誠'
      fill_in 'form_customer_family_name_kana', with: 'ニシジマ'
      fill_in 'form_customer_given_name_kana', with: 'マコト'
      fill_in '生年月日', with: '1975-03-01'
      choose '男性'
    end

    click_on '登録'

    new_customer = Customer.order(:id).last
    expect(new_customer.email).to eq 'makoto.nishijima@example.com'
    expect(new_customer.family_name).to eq '西島'
    expect(new_customer.given_name_kana).to eq 'マコト'
    expect(new_customer.birthday).to eq Date.new(1975, 3, 1)
    expect(new_customer.gender).to eq 'male'
    expect(new_customer.home_address).to be_nil
    expect(new_customer.work_address).to be_nil
  end

  scenario '職員が顧客の基本情報、自宅住所、勤務先を更新する' do
    click_link '顧客管理'
    all('table.listing > tr')[2].click_link '編集'

    fill_in 'メールアドレス', with: 'test@example.com'
    within('fieldset#home-address-fields') do
      fill_in '郵便番号', with: '9999999'
    end
    within('fieldset#work-address-fields') do
      fill_in '会社名', with: '西島Web製作所'
    end

    click_on '更新'

    customer1.reload
    expect(customer1.email).to eq 'test@example.com'
    expect(customer1.home_address.postal_code).to eq '9999999'
    expect(customer1.work_address.company_name).to eq '西島Web製作所'
  end

  scenario '職員が勤務先情報がない顧客に会社名を追加する' do
    customer1.work_address.destroy
    click_link '顧客管理'
    all('table.listing > tr')[2].click_link '編集'

    check '勤務先を入力する'
    within('fieldset#work-address-fields') do
      fill_in '会社名', with: '西島Web製作所'
    end

    click_on '更新'

    customer1.reload
    expect(customer1.work_address.company_name).to eq '西島Web製作所'
  end

  scenario '職員が顧客の郵便番号と生年月日に無効な値を入力して更新しようとする' do
    click_link '顧客管理'
    all('table.listing > tr')[2].click_link '編集'

    fill_in 'メールアドレス', with: ''
    fill_in '生年月日', with: '1800-01-01'
    within('fieldset#home-address-fields') do
      fill_in '郵便番号', with: 'xyz'
    end
    within('fieldset#work-address-fields') do
      fill_in '会社名', with: ''
      fill_in '郵便番号', with: 'abc'
    end

    click_on '更新'

    expect(page).to have_css 'header > span.alert'
    expect(page).to have_css 'div.field_with_errors > input#form_customer_email'
    expect(page).to have_css 'div.field_with_errors > input#form_customer_birthday'
    expect(page).to have_css 'div.field_with_errors > input#form_home_address_postal_code'
    expect(page).to have_css 'div.field_with_errors > input#form_work_address_company_name'
    expect(page).to have_css 'div.field_with_errors > input#form_work_address_postal_code'
  end

end
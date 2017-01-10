require 'rails_helper'

RSpec.describe HomeAddress, type: :model do
  describe 'バリデーション' do
    example '会社名に値が入っているとエラー' do
      home_address = build(:home_address, company_name: 'Company')
      home_address.valid?
      expect(home_address.errors.messages).to be_has_key :company_name
    end

    example '部署名に値が入っているとエラー' do
      home_address = build(:home_address, division_name: 'Division')
      home_address.valid?
      expect(home_address.errors.messages).to be_has_key :division_name
    end
  end
end

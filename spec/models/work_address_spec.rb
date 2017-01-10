require 'rails_helper'

RSpec.describe WorkAddress, type: :model do
  describe 'バリデーション' do
    example '会社名に値が入っていないとエラー' do
      work_address = build(:work_address, company_name: '')
      work_address.valid?
      expect(work_address.errors.messages).to be_has_key :company_name
    end
  end
end

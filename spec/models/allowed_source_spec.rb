require 'rails_helper'

RSpec.describe AllowedSource, type: :model do
  describe '#ip_address=' do
    let(:allowed_source) { AllowedSource.new(namespace: 'staff') }

    example '引数に"127.0.0.1" を与えた場合' do
      allowed_source.ip_address = '127.0.0.1'
      expect(allowed_source.octet1).to eq 127
      expect(allowed_source.octet2).to eq 0
      expect(allowed_source.octet3).to eq 0
      expect(allowed_source.octet4).to eq 1
      expect(allowed_source).not_to be_wildcard
      expect(allowed_source).to be_valid
    end

    example '引数に"192.168.0.*" を与えた場合' do
      allowed_source.ip_address = '192.168.0.*'
      expect(allowed_source.octet1).to eq 192
      expect(allowed_source.octet2).to eq 168
      expect(allowed_source.octet3).to eq 0
      expect(allowed_source.octet4).to eq 0
      expect(allowed_source).to be_wildcard
      expect(allowed_source).to be_valid
    end

    example '引数に不正な文字列を与えた場合' do
      allowed_source.ip_address = 'hoge.hoge'
      expect(allowed_source).not_to be_valid
    end
  end

  describe '.include?' do
    before :each do
      Rails.application.config.baukis[:restrict_ip_addresses] = true
      AllowedSource.create!(namespace: 'staff', ip_address: '127.0.0.1')
      AllowedSource.create!(namespace: 'staff', ip_address: '192.168.0.*')
    end

    example 'マッチしない場合' do
      expect(AllowedSource.include?('staff', '192.168.1.100')).to be_falsey
    end

    example '全オクテットがマッチする場合' do
      expect(AllowedSource.include?('staff', '127.0.0.1')).to be_truthy
    end

    example 'ワイルドカードでマッチする場合' do
      expect(AllowedSource.include?('staff', '192.168.0.100')).to be_truthy
    end
  end
end

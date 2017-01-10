require 'spec_helper'

describe String do
  describe '#<<' do
    example '文字の追加' do
      s = 'ABC'
      s << 'D'
      expect(s.size).to eq 4
    end

    example 'nilは追加できない' do
      s = 'abc'
      expect { s << nil }.to raise_error(TypeError)
    end

    example '整数の追加' do
      pending '調査中'
      s = 'xyz'
      s << 33
      expect(s).to eq 'xyz33'
    end
  end
end

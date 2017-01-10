class CustomerPresenter < ModelPresenter
  delegate :email, :family_name, :given_name, :family_name_kana, :given_name_kana, to: :object

  # 顧客の氏名を返す
  def full_name
    "#{family_name} #{given_name}"
  end

  # 顧客の氏名(カナ)を返す
  def full_name_kana
    "#{family_name_kana} #{given_name_kana}"
  end

  # 顧客の生年月日を整形(yyyy/mm/dd)して返す
  def birthday
    return '' if object.birthday.blank?
    object.birthday.strftime('%Y/%m/%d')
  end

  # 顧客の性別を返す
  def gender
    case object.gender
    when 'male'
      '男性'
    when 'female'
      '女性'
    else
      ''
    end
  end

  # 顧客の電話番号
  def personal_phones
    object.personal_phones.map(&:number)
  end
end

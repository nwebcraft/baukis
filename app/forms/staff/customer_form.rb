class Staff::CustomerForm
  include ActiveModel::Model

  attr_accessor :customer, :inputs_home_address, :inputs_work_address
  delegate :persisted?, :save, to: :customer

  def initialize(customer = nil)
    @customer = customer
    @customer ||= Customer.new(gender: 'male')
    @inputs_home_address = @customer.home_address.present?
    @inputs_work_address = @customer.work_address.present?
    @customer.build_home_address unless @customer.home_address
    @customer.build_work_address unless @customer.work_address
    (2 - @customer.personal_phones.size).times do
      @customer.personal_phones.build
    end
    (2 - @customer.home_address.phones.size).times do
      @customer.home_address.phones.build
    end
    (2 - @customer.work_address.phones.size).times do
      @customer.work_address.phones.build
    end
  end

  def assign_attributes(params = {})
    @params = params

    self.inputs_home_address = @params[:inputs_home_address] == '1'
    self.inputs_work_address = @params[:inputs_work_address] == '1'

    customer.assign_attributes(customer_params)

    # 電話番号(個人)
    phones = phone_params(:customer).fetch(:phones)
    customer.personal_phones.size.times do |index|
      attributes = phones[index.to_s]
      if attributes && attributes[:number].present?
        customer.personal_phones[index].assign_attributes(attributes)
      else
        customer.personal_phones[index].mark_for_destruction
      end
    end

    if inputs_home_address
      customer.home_address.assign_attributes(home_address_params)

      # 自宅電話番号
      phones = phone_params(:home_address).fetch(:phones)
      customer.home_address.phones.size.times do |index|
        attributes = phones[index.to_s]
        if attributes && attributes[:number].present?
          customer.home_address.phones[index].assign_attributes(attributes)
        else
          customer.home_address.phones[index].mark_for_destruction
        end
      end
    else
      customer.home_address.mark_for_destruction
    end

    if inputs_work_address
      customer.work_address.assign_attributes(work_address_params)

      # 勤務先電話番号
      phones = phone_params(:work_address).fetch(:phones)
      customer.work_address.phones.size.times do |index|
        attributes = phones[index.to_s]
        if attributes && attributes[:number].present?
          customer.work_address.phones[index].assign_attributes(attributes)
        else
          customer.work_address.phones[index].mark_for_destruction
        end
      end
    else
      customer.work_address.mark_for_destruction
    end
  end


  private

  def customer_params
    @params.require(:customer).permit(
      :email,
      :family_name, :given_name,
      :family_name_kana, :given_name_kana,
      :birthday, :gender,
      :password
    )
  end

  def home_address_params
    @params.require(:home_address).permit(
      :postal_code,
      :prefecture, :city,
      :address1, :address2
    )
  end

  def work_address_params
    @params.require(:work_address).permit(
      :postal_code,
      :prefecture, :city,
      :address1, :address2,
      :company_name, :division_name
    )
  end

  def phone_params(recored_name)
    @params.require(recored_name).permit(phones: [:number, :primary])
  end
end

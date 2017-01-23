class ConfirmingAddressFormPresenter < ConfirmingFormPresenter
  def postal_code_block(name, label_text, options = {})
    markup(:div, class: 'input-block') do |m|
      m << decorated_label(name, label_text, options)
      m.div(object.send(name), class: 'field_value')
      m << hidden_field(name)
    end
  end
end

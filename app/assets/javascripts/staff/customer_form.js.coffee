$(document).on 'turbolinks:load', ->
  $("form.edit_form").on 'click', '#enable-password-field', ->
    $("#enable-password-field").hide()
    $("#disable-password-field").show()
    $("#form_customer_password").removeAttr('disabled')
    $("label[for='form_customer_password']").addClass('required')

  $("form.edit_form").on 'click', '#disable-password-field', ->
    $("#enable-password-field").show()
    $("#disable-password-field").hide()
    $("#form_customer_password").attr('disabled', 'disabled')
    $("label[for='form_customer_password']").removeClass('required')

  toggleHomeAddressFields()
  toggleWorkAddressFields()

  $("#form_inputs_home_address").on 'change', ->
    toggleHomeAddressFields()

  $("#form_inputs_work_address").on 'change', ->
    toggleWorkAddressFields()


toggleHomeAddressFields = ->
  checked = $("#form_inputs_home_address").prop('checked')
  $("#home-address-fields input").prop('disabled', !checked)
  $("#home-address-fields select").prop('disabled', !checked)
  $("#home-address-fields").toggle(checked)

toggleWorkAddressFields = ->
  checked = $("#form_inputs_work_address").prop('checked')
  $("#work-address-fields input").prop('disabled', !checked)
  $("#work-address-fields select").prop('disabled', !checked)
  $("#work-address-fields").toggle(checked)

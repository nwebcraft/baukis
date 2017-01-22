$(document).on 'turbolinks:load', ->
  return if $('div.confirming').length
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

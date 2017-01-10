$(document).on 'turbolinks:load', ->
  $("form.edit_staff_member").on 'click', '#enable-password-field', ->
    $("#enable-password-field").hide()
    $("#disable-password-field").show()
    $("#staff_member_password").removeAttr('disabled')
    $("label[for='staff_member_password']").addClass('required')
  $("form.edit_staff_member").on 'click', '#disable-password-field', ->
    $("#enable-password-field").show()
    $("#disable-password-field").hide()
    $("#staff_member_password").attr('disabled', 'disabled')
    $("label[for='staff_member_password']").removeClass('required')

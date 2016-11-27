// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugi1ns, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require select2-full
//= require turbolinks
//= require jquery-readyselector
//= require bootstrap-sprockets
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.pl.js
//= require select2_locale_pl
//= require moment.min.js
//= require nested_form_fields
//= require dropzone
//= require_tree .

function show_client_modal() {
  $('#new_client_modal').modal('toggle');
  $('#invoice_client_id').select2("close");
  $('#default_value_client_id').select2("close");
  $('#carrier_client_id').select2("close");
}

function show_communication_modal(invoice_id) {
  $('#new_communication_modal').modal('toggle');
  $('#new_communication_modal').find('#communication_invoice_id').val(invoice_id)
}

function show_client_modal_transport_order() {
  $("#new_client_modal").modal("toggle");
  $("#transport_order_client_id").select2("close");
  mail = $("#transport_order_client_email").val();
  modalMailInput = $("#new_client_modal").find(".email").find("input").first();
  modalMailInput.val(mail);
}

function show_item_modal() {
  $("#new_item_modal").modal("toggle");
  $(".invoice_items_form").find("select").select2("close");
}

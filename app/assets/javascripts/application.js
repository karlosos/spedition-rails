// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
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
//= require_tree .
//= require bootstrap
//= require bootstrap-datepicker
//= require bootstrap-datepicker/locales/bootstrap-datepicker.pl.js
//= require select2_locale_pl
//= require moment.min.js


function show_client_modal() {
  $('#new_client_modal').modal('toggle')
  $('#invoice_client_id').select2("close")
}

function show_item_modal() {
  $('#new_item_modal').modal('toggle')
  $('.invoice_items_form').find('select').select2("close")
}

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

$(document).ready(function(){
  // client
  $(document).bind("ajax:success",'form#new_client', function(evt, data, status, xhr){
     var $form = $(this);
     $('#new_client_modal').modal_success();
     var option = $('<option selected>'+data.name+'</option>').val(""+data.id);
     console.log(option)
     $("#invoice_client_id").append(option).trigger('change');
   })

  $(document).bind('ajaxError', 'form#new_client', function(event, jqxhr, settings, exception){

    // note: jqxhr.responseJSON undefined, parsing responseText instead
    $(event.data).render_form_errors( $.parseJSON(jqxhr.responseText) );

  });

  $('#new_client_modal').on('shown.bs.modal', function () {
    $('#client_name').focus()
  })

  // item
  $(document).bind("ajax:success",'form#new_item', function(evt, data, status, xhr){
    console.log("item")
     var $form = $(this);
     $('#new_item_modal').modal_success();
     //var option = $('<option selected>'+data.name+'</option>').val(""+data.id);
     //console.log(option)
     //$("#invoice_client_id").append(option).trigger('change');
   })

  $(document).bind('ajaxError', 'form#new_item', function(event, jqxhr, settings, exception){

    // note: jqxhr.responseJSON undefined, parsing responseText instead
    $(event.data).render_form_errors( $.parseJSON(jqxhr.responseText) );

  });

  $('#new_item_modal').on('shown.bs.modal', function () {
    $('#item_name').focus()
  })
});

(function($) {

  $.fn.modal_success = function(){
    // close modal
    this.modal('hide');

    // clear form input elements
    // todo/note: handle textarea, select, etc
    this.find('form input[type="text"]').val('');

    // clear error state
    this.clear_previous_errors();
  };

  $.fn.render_form_errors = function(errors){

    console.log('chce rendererowarac errory');

    $form = this;
    this.clear_previous_errors();
    model = this.data('model');

    console.log(model)
    //client_contact_attributes_fax
    // show error messages in input form-group help-block
    $.each(errors, function(field, messages){
      console.log(field)
      if(field.search('[.]') > 0) {
        association = field.substring(0, field.search('[.]'));
        association = association + "_attributes";
        attribute = field.substring(field.search('[.]')+1);
        $input = $('input[name="' + model + '[' + association + ']' + '[' + attribute + ']"]');
        console.log('input[name="' + model + '[' + association + ']' + '[' + attribute + ']"]');
        $input.closest('.form-group').addClass('has-error').find('.help-block').html( messages.join(' & ') );
      } else {
      $input = $('input[name="' + model + '[' + field + ']"]');
      console.log('input[name="' + model + '[' + field + ']"]')
      $input.closest('.form-group').addClass('has-error').find('.help-block').html( messages.join(' & ') );
      }
    });

  };

  $.fn.clear_previous_errors = function(){
    $('.form-group.has-error', this).each(function(){
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    });
  }

}(jQuery));


function show_client_modal() {
  $('#new_client_modal').modal('toggle')
  $('#invoice_client_id').select2("close")
}

function show_item_modal() {
  $('#new_item_modal').modal('toggle')
  $('#invoice_client_id').select2("close")
}

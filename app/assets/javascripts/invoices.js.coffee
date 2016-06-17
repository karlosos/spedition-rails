jQuery ->
  $('form').on 'click', '.remove_invoice_items', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('li').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()
    $('.invoice_items_form').find('select').select2
        theme: 'bootstrap'


  $('#invoice_client_id').select2
    theme: 'bootstrap'
    ajax:
      url: '/clients.json'
      dataType: 'json'
      processResults: (data) ->
        return {
        results: $.map(data, (client, i) ->
          {
            id: client.id
            text: client.name
          }
       )}

  $('#invoice_seller_id').select2
    theme: 'bootstrap'
    ajax:
      url: '/clients.json'
      dataType: 'json'
      processResults: (data) ->
        return {
        results: $.map(data, (client, i) ->
          {
            id: client.id
            text: client.name
          }
       )}

    $('.invoice_items_form').find('select').select2
        theme: 'bootstrap'

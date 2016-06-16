jQuery ->
  $('form').on 'click', '.remove_invoice_items', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('li').hide()
    event.preventDefault()

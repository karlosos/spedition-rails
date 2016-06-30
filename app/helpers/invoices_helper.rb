module InvoicesHelper
  def link_to_menu_invoice(text, glyphicon_class, link, delete = 0)
    html = "<span class='glyphicon #{glyphicon_class}' aria-hidden='true'></span> #{text}"
    if delete == 1
      link_to(raw(html), link, method: :delete, data: { confirm: 'Are you sure?' } )
    else
      link_to(raw(html), link)
    end
  end
end

module TransportOrdersHelper
  def prev_month_link(year, month, speditor_id)
    new_month = month.to_i - 1
    new_year = year.to_i
    if new_month < 1
      new_month = 12
      new_year = new_year - 1
    end

    return link_to "#{new_month}/#{new_year}", speditor_view_path(:year => new_year, :month => new_month, :speditor_id => speditor_id)
  end

  def next_month_link(year, month, speditor_id)
    new_month = month.to_i + 1
    new_year = year.to_i
    if new_month > 12
      new_month = 1
      new_year = new_year + 1
    end

    return link_to "#{new_month}/#{new_year}", speditor_view_path(:year => new_year, :month => new_month, :speditor_id => speditor_id)
  end
end

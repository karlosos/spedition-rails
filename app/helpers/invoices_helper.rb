module InvoicesHelper
  def overdue_class_for(days)
    if days >= 30
      return 'btn-success'
    elsif days < 30 && days > 0
      return 'btn-warning'
    elsif days <= 0
      return 'btn-danger'
    end
  end
end

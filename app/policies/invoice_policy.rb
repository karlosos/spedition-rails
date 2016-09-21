class InvoicePolicy < ApplicationPolicy
  attr_reader :user, :invoice

  def initialize(user, invoice)
    @user = user
    @invoice = invoice
  end

  def index?
    is_logged_in?
  end

  def show?
    is_in_same_group? || is_site_admin?
  end

  def new?
    is_logged_in?
  end

  def create?
    is_logged_in?
  end

  def edit?
    is_in_same_group? || is_site_admin?
  end

  def update?
    is_in_same_group? || is_site_admin?
  end

  def destroy?
    is_in_same_group? || is_site_admin?
  end

  def new_correction?
    has_acces_to_parent_invoice = @invoice.invoice_to_correct.shares_any_group?(user)
    is_logged_in? && has_acces_to_parent_invoice
  end

  def new_invoice_from_transport_orders?
    # has_acces_to_parent_transport_order = true
    # @invoice.items.each do |item|
    #   if item.transport_order.present?
    #     item.transport_order.shares_any_group?(user)
    #   end
    # end
    # is_logged_in? && has_acces_to_parent_transport_order
    is_logged_in?
  end

  def last_invoice_number_for_date?
    true
  end

  private

  def is_site_admin?
    !user.nil? && user.in_named_group?(:admin)
  end

  def is_in_same_group?
    !user.nil? && invoice.shares_any_group?(user)
  end

  def is_logged_in?
    !user.nil?
  end
end

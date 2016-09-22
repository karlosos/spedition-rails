class TransportOrderPolicy < ApplicationPolicy
  attr_reader :user, :transport_order

  def initialize(user, transport_order)
    @user = user
    @transport_order = transport_order
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

  def create_name?
    # TO DO IS AN ACCOUNTANT
    is_in_same_group? || is_site_admin?
  end

  def speditor_view?
    is_logged_in?
  end

  def accounting_view?
    is_logged_in?
  end

  private

  def is_site_admin?
    !user.nil? && user.in_named_group?(:admin)
  end

  def is_in_same_group?
    !user.nil? && transport_order.shares_any_group?(user)
  end

  def is_logged_in?
    !user.nil?
  end
end

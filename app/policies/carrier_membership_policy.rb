class CarrierMembershipPolicy < ApplicationPolicy
  attr_reader :user, :carrier_membership

  def initialize(user, carrier_membership)
    @user = user
    @carrier_membership = carrier_membership
  end

  def index?
    is_logged_in?
  end

  def show?
    is_owner? || is_site_admin?
  end

  def new?
    is_logged_in?
  end

  def create?
    is_owner? || is_site_admin?
  end

  def edit?
    is_owner? || is_site_admin?
  end

  def update?
    is_owner? || is_site_admin?
  end

  def destroy?
    is_owner? || is_site_admin?
  end

  private

  def is_site_admin?
    !user.nil? && user.in_named_group?(:admin)
  end

  def is_owner?
    !user.nil? && carrier_membership.user == user
  end

  def is_logged_in?
    !user.nil?
  end
end

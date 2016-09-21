class ItemPolicy < ApplicationPolicy
  attr_reader :user, :item

  def initialize(user, item)
    @user = user
    @item = item
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

  private

  def is_site_admin?
    !user.nil? && user.in_named_group?(:admin)
  end

  def is_in_same_group?
    !user.nil? && item.shares_any_group?(user)
  end

  def is_logged_in?
    !user.nil?
  end
end

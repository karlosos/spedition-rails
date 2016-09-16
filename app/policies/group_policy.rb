class GroupPolicy < ApplicationPolicy
  attr_reader :user, :group

  def initialize(user, group)
    @user = user
    @group = group
  end

  def index?
    is_site_admin?
  end

  def show?
    is_owner?
  end

  def new?
    is_logged_in?
  end

  def create?
    is_logged_in?
  end

  def edit?
    is_owner?
  end

  def update?
    is_owner?
  end

  def destroy?
    is_owner?
  end

  private

  def is_site_admin?
    !user.nil? && user.in_named_group?(:admin)
  end

  def is_owner?
    !user.nil? && user.in_group?(group, as: 'admin')
  end

  def is_logged_in?
    !user.nil?
  end
end

class ApplicationController < ActionController::Base
  include Pundit
  before_action :check_subdomain
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def check_subdomain
    if request.subdomain.present?
      group = Group.find_by_subdomain(request.subdomain)
      if group
        if current_user
          if current_user.in_group?(group)
            @group = group
          else
            redirect_to root_url(subdomain: false)
          end
        end
      else
        redirect_to root_url(subdomain: false)
      end
    end
  end

  private
  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_to(request.referrer || root_path)
  end
end

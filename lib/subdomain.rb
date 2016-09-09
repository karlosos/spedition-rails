class Subdomain
  def self.matches?(request)
    request.subdomain.present? && Group.exists?(subdomain: request.subdomain)
  end
end

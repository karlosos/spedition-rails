class GmailController < ApplicationController
  require 'google/apis/gmail_v1'
  require 'rmail'


  def loading_transport_order_email
    transport_order = TransportOrder.find(params[:id])
    send_email(transport_order.client_email + "test", "subject", "content")
    transport_order.loading_status = true
    transport_order.save
  end

  def unloading_transport_order_email
    transport_order = TransportOrder.find(params[:id])
    send_email(transport_order.client_email + "test", "subject", "content")
    transport_order.unloading_status = true
    transport_order.save
  end

  def invoice_email
    invoice = Invoice.find(params[:id])
    send_email(invoice.client.emails.last.address + "test", "subject", "content")
    invoice.status = 2
    invoice.save
  end

  private

  def send_email(address, subject, content)
    configure_client()
    message = RMail::Message.new
    message.header['To'] = address
    message.header['From'] = current_user.email
    message.header['Subject'] = subject
    message.body = content
    begin
      flash[:notice] = "Wysłano maila"
      @service.send_user_message('me', upload_source: StringIO.new(message.to_s), content_type: 'message/rfc822')
      redirect_to :back
    rescue Google::Apis::AuthorizationError
      flash[:notice] = "Nie jesteś zalogowany kontem google"
      redirect_to user_google_oauth2_omniauth_authorize_url(subdomain: false)
    end
  end

  def configure_client()
    @service = Google::Apis::GmailV1::GmailService.new
    reauthorize()
    access_token = AccessToken.new current_user.access_token
    @service.authorization = access_token
  end

  def reauthorize
    options = {
      body: {
      client_id: ENV["google_client_id"],
      client_secret: ENV["google_client_secret"],
      refresh_token: "#{current_user.refresh_token}",
      grant_type: 'refresh_token'
      },
      headers: {
        'Content-Type' => 'application/x-www-form-urlencoded'
      }
    }
    refresh = HTTParty.post("https://accounts.google.com/o/oauth2/token", options)
    if refresh.code == 200
      current_user.access_token = refresh.parsed_response['access_token']
      current_user.save
    end
  end
end

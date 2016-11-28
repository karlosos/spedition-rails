class GmailController < ApplicationController
  require 'google/apis/gmail_v1'
  require 'rmail'


  def loading_transport_order_email
    transport_order = TransportOrder.find(params[:id])
    mail_template = @group.default_value.mail_templates.find_by(type: "loading")
    subject = replace_transport_order_message(mail_template.subject, transport_order)
    content = replace_transport_order_message(mail_template.content, transport_order)

    send_email(transport_order.client_email + "test", subject, content)
    transport_order.loading_status = true
    transport_order.save
  end

  def unloading_transport_order_email
    transport_order = TransportOrder.find(params[:id])
    mail_template = @group.default_value.mail_templates.find_by(type: "unloading")
    subject = replace_transport_order_message(mail_template.subject, transport_order)
    content = replace_transport_order_message(mail_template.content, transport_order)

    send_email(transport_order.client_email + "test", subject, content)
    transport_order.unloading_status = true
    transport_order.save
  end

  def invoice_email
    invoice = Invoice.find(params[:id])
    send_email(invoice.client.emails.last.address + "test", "subject", "content")
    invoice.status = 2
    invoice.save
  end

  def vindication_email
    invoice = Invoice.find(params[:id])
    emails = invoice.vindication_emails
    mail_template = @group.default_value.mail_templates.find_by(email_type: "vindication_#{params[:email_type]}")
    subject = replace_vindication_message(mail_template.subject, invoice)
    content = replace_vindication_message(mail_template.content, invoice)
    send_email(emails + "test", subject, content)
    invoice.vindication_last_email_type = params[:email_type]
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

  def replace_transport_order_message(message, transport_order)
    message = message.gsub("{0}", transport_order.route)
    message = message.gsub("{1}", transport_order.carrier.registration_number)
    message = message.gsub("{2}", transport_order.carrier.size)
    message = message.gsub("{3}", transport_order.carrier.driver_name)
    return message
  end

  def replace_vindication_message(message, invoice)
    message = message.gsub("{0}", invoice.get_name)
    message = message.gsub("{1}", ActionController::Base.helpers.humanized_money(invoice.total_selling_price))
    message = message.gsub("{2}", (invoice.overdue*(-1)).to_i.to_s)
    return message
  end
end

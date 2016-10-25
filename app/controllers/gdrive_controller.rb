class GdriveController < ApplicationController
  require 'google/apis/drive_v2'

  def test
    #configure_client()
    # # Search for files in Drive (first page only)
    # files = drive.list_files(q: "title contains 'finances'")
    # files.items.each do |file|
    #   puts file.title
    # end

    # Upload a file
    #metadata = Google::Apis::DriveV2::File.new(title: 'Test')
    #metadata = @drive.insert_file(metadata, upload_source: 'Gemfile', content_type: 'text/plain')

    #Download a file
    #@drive.get_file(metadata.id, download_dest: '/tmp/myfile.txt')
  end

  def upload
    file = params[:file]
    #byebug
    configure_client()
    file_obj = Google::Apis::DriveV2::File.new({
      title: file.original_filename,
      #parents: file[:parent_ids]
    })
    f = @drive.insert_file(file_obj, upload_source: file.tempfile)
    f.id
    redirect_to root_path
  rescue
    nil
    redirect_to root_path
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
    @drive = Google::Apis::DriveV2::DriveService.new
    reauthorize()
    access_token = AccessToken.new current_user.access_token
    @drive.authorization = access_token # See Googleauth or Signet libraries
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

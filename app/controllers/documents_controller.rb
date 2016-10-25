class DocumentsController < ApplicationController
  def index
    @documents = Document.all
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    file = params[:document][:attachment]
    #byebug
    configure_client()
    parent_folder = Google::Apis::DriveV2::ParentReference.new()
    parent_folder.id = @group.folder_id
    file_obj = Google::Apis::DriveV2::File.new({
      title: file.original_filename,
      parents: [parent_folder,]
    })
    f = @drive.insert_file(file_obj, upload_source: file.tempfile)
    f.id
    if f.id.present?
      @document.file_id = f.id
      @document.web_content_link = f.web_content_link
      if @document.save
        @group.add(@document)
        redirect_to documents_path, notice: "Dokument #{@document.name} zostal zapisany"
      else
        render "new"
      end
    end
  end

  def upload
    @document = Document.new()
    @document.transport_order_id = params[:transport_order_id]
    @document.type = params[:type]
    file = params[:file]
    #byebug
    configure_client()
    parent_folder = Google::Apis::DriveV2::ParentReference.new()
    parent_folder.id = @group.folder_id
    file_obj = Google::Apis::DriveV2::File.new({
      title: file.original_filename,
      parents: [parent_folder,]
    })
    f = @drive.insert_file(file_obj, upload_source: file.tempfile)
    f.id
    if f.id.present?
      @document.file_id = f.id
      @document.web_content_link = f.web_content_link
      if @document.save
        @group.add(@document)
        redirect_to documents_path, notice: "Dokument #{@document.name} zostal zapisany"
      else
        render "new"
      end
    end
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    redirect_to documents_path, notice: "Dokument #{@document.name} zostal usuniety"
  end

  def upload
    file = params[:file]
    #byebug
    configure_client()
    parent_folder = Google::Apis::DriveV2::ParentReference.new()
    parent_folder.id = @group.folder_id
    file_obj = Google::Apis::DriveV2::File.new({
      title: file.original_filename,
      parents: [parent_folder,]
    })
    f = @drive.insert_file(file_obj, upload_source: file.tempfile)
    f.id
    redirect_to :back
  rescue
    nil
    redirect_to :back
  end

  private
  def document_params
    params.require(:document).permit(:transport_order_id, :type, :name)
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

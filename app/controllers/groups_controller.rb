class GroupsController < ApplicationController
  require 'google/apis/drive_v2'
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
    authorize @groups
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    authorize @group
  end

  # GET /groups/new
  def new
    @group = Group.new
    authorize @group
  end

  # GET /groups/1/edit
  def edit
    authorize @group
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    authorize @group
    respond_to do |format|
      if @group.save
        @group.add(current_user, as: 'admin')
        folder_id = create_folder(@group.subdomain)
        @group.folder_id = folder_id
        @group.save
        format.html { redirect_to edit_default_values_group_info_url(@group, subdomain: @group.subdomain), notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    authorize @group
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    authorize @group
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_users_to_group
    group = Group.find(params[:id])
    @group = group
    emails = params["user_emails"]
    password = params["default_password"]
    role = params["membership_type"]
    error = ""
    emails.each do |email|
      user = User.find_by_email(email)
      if user
        group.add(user, as: role)

        error += "Dodano #{email} do grupy. "
      else
        user = User.new
        user.email = email
        user.password = password
        user.save
        if password.length < 6
          error = "Nie dodano #{email} do grupy, hasło za krótkie (min 6 znaków)."
        else
          group.add(user, as: role)
        end
      end
      share_folder(email)
    end

    redirect_to :back, :notice => error
  end

  def remove_user_from_group
    group = Group.find(params[:id])
    user = User.find_by_email(params[:user_email])
    group.users.delete(user)

    redirect_to :back
  end

  def remove_user_role_from_group
    group = Group.find(params[:id])
    user = User.find_by_email(params[:user_email])
    role = params["membership_type"]
    group.users.delete(user, as: role)

    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :subdomain)
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

    def create_folder(folder_name)
      configure_client()
      folder_metadata = Google::Apis::DriveV2::File.new({
        title: folder_name,
        mime_type: 'application/vnd.google-apps.folder'
      })

      folder = @drive.insert_file(folder_metadata, fields: 'id')
      return folder.id
    end

    def share_folder(email)
      configure_client()
      permission = Google::Apis::DriveV2::Permission.new
      permission.value = email
      permission.role = 'writer'
      permission.type = 'user'
      #byebug
      @drive.insert_permission(@group.folder_id, permission)
    end
end

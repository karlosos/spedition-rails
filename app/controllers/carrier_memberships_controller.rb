class CarrierMembershipsController < ApplicationController
  before_action :set_carrier_membership, only: [:show, :edit, :update, :destroy]

  # GET /carrier_memberships
  # GET /carrier_memberships.json
  def index
    @carrier_memberships = current_user.carrier_memberships
    authorize @carrier_memberships
  end

  # GET /carrier_memberships/1
  # GET /carrier_memberships/1.json
  def show
    authorize @carrier_membership
  end

  # GET /carrier_memberships/new
  def new
    @carrier_membership = CarrierMembership.new
    @carrier_membership.user = current_user
    authorize @carrier_membership
  end

  # GET /carrier_memberships/1/edit
  def edit
    authorize @carrier_membership
  end

  # POST /carrier_memberships
  # POST /carrier_memberships.json
  def create
    @carrier_membership = CarrierMembership.new(carrier_membership_params)
    authorize @carrier_membership
    respond_to do |format|
      if @carrier_membership.save
        format.html { redirect_to carrier_memberships_path, notice: 'Carrier membership was successfully created.' }
        format.json { render :show, status: :created, location: @carrier_membership }
      else
        format.html { render :new }
        format.json { render json: @carrier_membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carrier_memberships/1
  # PATCH/PUT /carrier_memberships/1.json
  def update
    authorize @carrier_membership
    respond_to do |format|
      if @carrier_membership.update(carrier_membership_params)
        format.html { redirect_to carrier_memberships_url, notice: 'Carrier membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @carrier_membership }
      else
        format.html { render :edit }
        format.json { render json: @carrier_membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carrier_memberships/1
  # DELETE /carrier_memberships/1.json
  def destroy
    authorize @carrier_membership
    @carrier_membership.destroy
    respond_to do |format|
      format.html { redirect_to carrier_memberships_url, notice: 'Carrier membership was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_carrier_membership
      @carrier_membership = CarrierMembership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def carrier_membership_params
      params.fetch(:carrier_membership, {})
      params.require(:carrier_membership).permit(:carrier_id, :user_id)
    end
end

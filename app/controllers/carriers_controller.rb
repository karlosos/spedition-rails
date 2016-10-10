class CarriersController < ApplicationController
  before_action :set_carrier, only: [:show, :edit, :update, :destroy]

  # GET /carriers
  # GET /carriers.json
  def index
    search_params = { :registration_number => params[:registration_number], :carrier_name => params[:carrier_name],
      :driver_name => params[:driver_name]
    }
    @carriers = Carrier.all.search(search_params).in_any_group(@group)
    @carriers = @carriers.order(sort_column + " " + sort_direction)
    @carriers = @carriers.paginate(:page => params[:page], :per_page => 30)
    authorize @carriers
  end

  # GET /carriers/1
  # GET /carriers/1.json
  def show
    authorize @carrier
  end

  # GET /carriers/new
  def new
    @carrier = Carrier.new
    @carrier.build_address
    @carrier.build_contact
    @carrier.contact.emails.build
    authorize @carrier
  end

  # GET /carriers/1/edit
  def edit
    authorize @carrier
  end

  # POST /carriers
  # POST /carriers.json
  def create
    @carrier = Carrier.new(carrier_params)
    authorize @carrier
    respond_to do |format|
      if @carrier.save
        @group.add(@carrier)
        format.html { redirect_to @carrier, notice: 'Carrier was successfully created.' }
        format.json { render :show, status: :created, location: @carrier }
      else
        format.html { render :new }
        format.json { render json: @carrier.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carriers/1
  # PATCH/PUT /carriers/1.json
  def update
    authorize @carrier
    respond_to do |format|
      if @carrier.update(carrier_params)
        format.html { redirect_to @carrier, notice: 'Carrier was successfully updated.' }
        format.json { render :show, status: :ok, location: @carrier }
      else
        format.html { render :edit }
        format.json { render json: @carrier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carriers/1
  # DELETE /carriers/1.json
  def destroy
    authorize @carrier
    @carrier.destroy
    respond_to do |format|
      if @carrier.errors.messages.any?
        notice = ''
        @carrier.errors.messages.each do |message|
          notice += message[1][0]
        end
      else
        notice = 'Carrier was successfully destroyed.'
      end
      format.html { redirect_to carriers_url, notice: notice }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_carrier
      @carrier = Carrier.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def carrier_params
      params.require(:carrier).permit(:registration_number, :size, :driver_name,
      :is_third_party, :driver_email, :carrier_name, :carrier_email,
      address_attributes: [:street, :line1, :line2, :city, :state, :country,
        :zip], contact_attributes: [:phone1, :phone2, :fax, :email, :www,
          emails_attributes: [:address]])
    end

    def sort_column
      # Client.joins(:address).joins(:contact).column_names.include?(params[:sort]) ? params[:sort] : "name"
      if params[:sort].present?
        params[:sort]
      else
        "carrier_name"
      end
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end

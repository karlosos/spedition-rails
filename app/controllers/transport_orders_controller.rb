class TransportOrdersController < ApplicationController
  before_action :set_transport_order, only: [:show, :edit, :update, :destroy]

  # GET /transport_orders
  # GET /transport_orders.json
  def index
    search_params = {
      :transport_order_name_number => params[:transport_order_name_number],
      :transport_order_name_year => params[:transport_order_name_year],
      :freight_rate_cents => params[:freight_rate],
      :zip => params[:zip],
      :city => params[:city],
      :client_name => params[:client_name],
      :client_id => params[:client_id],
      :carrier_name => params[:carrier_name],
      :driver_name => params[:driver_name],
      :registration_number => params[:registration_number],
      :loading_date => params[:loading_date],
      :unloading_date => params[:unloading_date],
      :loading_statuses => params[:loading_statuses],
      :loading_date_start => params[:loading_date_start],
      :loading_date_stop => params[:loading_date_stop],
      :unloading_date_start => params[:unloading_date_start],
      :unloading_date_stop => params[:unloading_date_stop],
      :loading_statuses => params[:loading_statuses]
    }

    @transport_orders = TransportOrder.joins(:transport_order_name)
    @transport_orders = @transport_orders.joins(:client, :carrier, :loading_places, :unloading_places)
    @transport_orders = @transport_orders.search(search_params)
    @transport_orders = @transport_orders.order(sort_column + " " + sort_direction)
    @transport_orders = @transport_orders.paginate(:page => params[:page], :per_page => 30)
  end

  def speditor_view
    @client = Client.new
    @client.build_address
    @client.build_contact
    @client.contact.emails.build

    speditor_id = params[:speditor_id]
    date = params[:date]
    @carriers = Carrier.all.joins(:transport_orders).distinct
    @transport_orders = Array.new
    for i in 0..@carriers.count
      transport_order = TransportOrder.new
      transport_order.build_transport_order_name
      transport_order.build_transport_order_name.year = Date.today.year
      transport_order.build_freichtage_description
      transport_order.loading_places.build
      transport_order.unloading_places.build
      @transport_orders << transport_order
    end
  end

  # GET /transport_orders/1.joins(:transport_order_name).joins(:client).joins(:carrier).joins(:loading_places).joins(:unloading_places)
  # GET /transport_orders/1.json
  def show
  end

  # GET /transport_orders/new
  def new
    @transport_order = TransportOrder.new
    @transport_order.build_transport_order_name
    @transport_order.build_transport_order_name.year = Date.today.year
    @transport_order.build_freichtage_description
    @transport_order.loading_places.build
    @transport_order.unloading_places.build
  end

  # GET /transport_orders/1/edit
  def edit
  end

  # POST /transport_orders
  # POST /transport_orders.json
  def create
    @transport_order = TransportOrder.new(transport_order_params)

    respond_to do |format|
      if @transport_order.save
        format.html { redirect_to @transport_order, notice: 'Transport order was successfully created.' }
        format.json { render :show, status: :created, location: @transport_order }
      else
        format.html { render :new }
        format.json { render json: @transport_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transport_orders/1
  # PATCH/PUT /transport_orders/1.json
  def update
    respond_to do |format|
      if @transport_order.update(transport_order_params)
        format.html { redirect_to @transport_order, notice: 'Transport order was successfully updated.' }
        format.json { render :show, status: :ok, location: @transport_order }
      else
        format.html { render :edit }
        format.json { render json: @transport_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transport_orders/1
  # DELETE /transport_orders/1.json
  def destroy
    @transport_order.destroy
    respond_to do |format|
      format.html { redirect_to transport_orders_url, notice: 'Transport order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transport_order
      @transport_order = TransportOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transport_order_params
      params.require(:transport_order).permit(:unloading_status, :loading_status,
      :client_id, :carrier_id, :seller_id, :distance_id, :freight_rate, :profit_margin,
      :loading_country, :loading_zip, :loading_city, :loading_date, :unloading_country,
      :unloading_zip, :distance, :unloading_city, :unloading_date, :route, :client_email,
      transport_order_name_attributes: [:number, :year],
      loading_places_attributes: [ :id, :zip, :city, :country],
      unloading_places_attributes: [ :id, :zip, :city, :country],
      freichtage_description_attributes: [ :weight, :value, :length, :width, :height, :packages, :packages_type ],
      transport_order_name: [:number, :year],
      loading_places: [ :id, :zip, :city, :country],
      unloading_places: [ :id, :zip, :city, :country],
      freichtage_description: [ :weight, :value, :length, :width, :height, :packages, :packages_type ])
    end

    def sort_column
      if params[:sort].present?
        params[:sort]
      else
        "created_at"
      end
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end

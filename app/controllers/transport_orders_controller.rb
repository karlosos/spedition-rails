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
      :carrier_id => params[:carrier_id],
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
    }

    @transport_orders = TransportOrder.joins(:transport_order_name)
    @transport_orders = @transport_orders.joins(:client, :carrier, :loading_places, :unloading_places)
    @transport_orders = @transport_orders.search(search_params).joins(:groups).where('groups.id = ?', @group.id)
    @transport_orders = @transport_orders.order(sort_column + " " + sort_direction)
    @transport_orders = @transport_orders.paginate(:page => params[:page], :per_page => 30)
    authorize @transport_orders
  end

  def speditor_view
    @client = Client.new
    @client.build_address
    @client.build_contact
    @client.contact.emails.build

    speditor_id = params[:speditor_id]
    speditor = User.find(speditor_id)
    year = params[:year]
    month = params[:month]
    @carriers = speditor.carriers.in_any_group(@group)
    @transport_orders = Array.new
    for i in 0..@carriers.count
      transport_order = TransportOrder.new
      transport_order.build_transport_order_name
      transport_order.build_transport_order_name.year = Date.today.year
      transport_order.build_freichtage_description
      transport_order.loading_places.build
      transport_order.unloading_places.build
      transport_order.seller_id = @group.default_value.client_id

      @transport_orders << transport_order
    end
    authorize @transport_orders[0]
  end

  def accounting_view
    @client = Client.new
    @client.build_address
    @client.build_contact
    @client.contact.emails.build

    @transport_orders = TransportOrder
    @transport_orders = @transport_orders.joins(:client, :carrier, :loading_places, :unloading_places, :groups).where('groups.id = ?', @group.id)
    @transport_orders = @transport_orders.order(sort_column + " " + sort_direction)
    @transport_orders = @transport_orders.paginate(:page => params[:page], :per_page => 30)
    authorize @transport_orders
  end

  # GET /transport_orders/1.joins(:transport_order_name).joins(:client).joins(:carrier).joins(:loading_places).joins(:unloading_places)
  # GET /transport_orders/1.json
  def show
    authorize @transport_order

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "#{@transport_order.transport_order_name.get_name}",
               encoding: "UTF-8"
      end
      format.json
    end
  end

  # GET /transport_orders/new
  def new
    @transport_order = TransportOrder.new
    authorize @transport_order

    @transport_order.build_freichtage_description
    @transport_order.loading_places.build
    @transport_order.unloading_places.build

    @transport_order.seller_id = @group.default_value.client_id

    @transport_order.arrangements = @group.default_value.arrangements
    @transport_order.vehicle_requirements = @group.default_value.vehicle_requirements
    @transport_order.additional_comments = @group.default_value.additional_comments
  end

  def create_name
    @transport_order = TransportOrder.find(params[:id])
    authorize @transport_order
    can_create_name = @transport_order.can_create_name
    if can_create_name.size == 0 && !@transport_order.transport_order_name.present?
      @transport_order.build_transport_order_name
      @transport_order.build_transport_order_name.year = Date.today.year
      @transport_order.transport_order_name.group = @group
      @transport_order.transport_order_name.number = TransportOrderName.get_last_number_for_year(Date.today.year, @group.id)
      if @transport_order.valid?
        item = Item.new()
        item.transport_order = @transport_order
        item.name = "Transportauftrag (usluga transportowa) #{@transport_order.route}"
        item.tax_rate_id = 23
        item.unit_price = @transport_order.freight_rate + @transport_order.profit_margin
        item.unit = "fracht"
        #byebug
        if item.save
          @group.add(item)
          @transport_order.save
        else
          flash.alert = "Zlecenie nie zostało stworzone"
        end
      end
    end
    if can_create_name.size != 0
      flash.notice = can_create_name
    end
    redirect_to :back
  end

  # GET /transport_orders/1/edit
  def edit
    @transport_order = TransportOrder.find(params[:id])
    authorize @transport_order
    if @transport_order.freichtage_description.present? == false
      @transport_order.build_freichtage_description
    end
  end

  # POST /transport_orders
  # POST /transport_orders.json
  def create
    @transport_order = TransportOrder.new(transport_order_params)
    authorize @transport_order
    respond_to do |format|
      if @transport_order.save
        @group.add(@transport_order)
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
    authorize @transport_order
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
    authorize @transport_order
    @transport_order.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Transport order was successfully destroyed.' }
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
      :driver_documents_status, :client_id, :carrier_id, :seller_id,
      :distance_id, :freight_rate, :profit_margin, :reference_transport_order_name,
      :loading_country, :loading_zip, :loading_city, :loading_date, :unloading_country,
      :unloading_zip, :distance, :unloading_city, :unloading_date, :route, :client_email,
      :car_registration_number, :carrier_driver_name, :cmr_number,
      transport_order_name_attributes: [:number, :year],
      loading_places_attributes: [ :id, :zip, :city, :country, :date],
      unloading_places_attributes: [ :id, :zip, :city, :country, :date],
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

class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  # GET /clients
  # GET /clients.json
  def index
    search_params = { :name => params[:name], :street => params[:street],
      :city => params[:city],
      :nip => params[:nip]
    }
    @clients = Client.joins(:address, :contact, :emails).in_any_group(@group)
    @clients = @clients.search(search_params)
    @clients = @clients.order(sort_column + " " + sort_direction)
    @clients = @clients.paginate(:page => params[:page], :per_page => 30)
    authorize @clients
    respond_to do |format|
      format.html
      if params[:q].present?
        query = params[:q].downcase
      else
        query = ""
      end
      query_sql = "lower(name) like ? OR lower(addresses.street) like ? OR
      lower(nip) like ? OR lower(city) like ? OR lower(zip) like ? OR
      lower(emails.address) like ?"
      @clients = @clients.where(query_sql, "%#{query}%", "%#{query}%", "%#{query}%",
      "%#{query}%", "%#{query}%", "#{query}").distinct.limit(15)
      format.json
    end
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    authorize @client
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /clients/new
  def new
    @client = Client.new
    @client.build_address
    @client.build_contact
    @client.contact.emails.build
    @client.invoice_currency = @group.default_value.invoice_currency
    @client.tax_rate_id = @group.default_value.tax_rate_id
    @client.invoice_language = @group.default_value.invoice_language
    @client.payment_term = @group.default_value.payment_term
    authorize @client
  end

  # GET /clients/1/edit
  def edit
    authorize @client
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)
    authorize @client
    respond_to do |format|
      if @client.save
        @group.add(@client)
        format.html { redirect_to @client, notice: 'Client was successfully created.' }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    authorize @client
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to @client, notice: 'Client was successfully updated.' }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    authorize @client
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Client was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      #params.fetch(:client, {})
      #params.require(:client).permit!
      params.require(:client).permit(:name, :nip, :invoice_currency, :tax_rate_id, :invoice_language, :payment_term, :accounting_email, address_attributes:
      [:street, :line1, :line2, :city, :state, :country, :zip],
      contact_attributes: [:phone1, :phone2, :fax, :email, :www,
        emails_attributes: [:id, :address]
      ],
      )
    end

    def sort_column
      # Client.joins(:address).joins(:contact).column_names.include?(params[:sort]) ? params[:sort] : "name"
      if params[:sort].present?
        params[:sort]
      else
        "name"
      end
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end

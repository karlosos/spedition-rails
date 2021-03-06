class DefaultValuesController < ApplicationController
  before_action :set_default_value, only: [:show, :edit, :update, :destroy]

  # GET /default_values
  # GET /default_values.json
  def index
    @default_values = DefaultValue.all
  end

  # GET /default_values/1
  # GET /default_values/1.json
  def show
  end

  # GET /default_values/new
  def new
    @default_value = DefaultValue.new
    @default_value.mail_templates.build
  end

  # GET /default_values/1/edit
  def edit
  end

  # GET /default_values/1/edit_invoice
  def edit_invoices
    @default_value = DefaultValue.find(params[:id])
  end

  # GET /default_values/1/edit_mail_template
  def edit_mail_templates
    @default_value = DefaultValue.find(params[:id])
  end

  # GET /default_values/1/edit_mail_template
  def edit_clients
    @default_value = DefaultValue.find(params[:id])
  end

  # GET /default_values/1/edit_transport_orders
  def edit_transport_orders
    @default_value = DefaultValue.find(params[:id])
  end

  # GET /default_values/1/edit_group_info
  def edit_group_info
    @client = Client.new
    @client.build_address
    @client.build_contact
    @client.contact.emails.build
    @default_value = DefaultValue.find(params[:id])
  end

  # POST /default_values
  # POST /default_values.json
  def create
    @default_value = DefaultValue.new(default_value_params)

    respond_to do |format|
      if @default_value.save
        format.html { redirect_to @default_value, notice: 'Default value was successfully created.' }
        format.json { render :show, status: :created, location: @default_value }
      else
        format.html { render :new }
        format.json { render json: @default_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /default_values/1
  # PATCH/PUT /default_values/1.json
  def update
    respond_to do |format|
      if @default_value.update(default_value_params)
        format.html { redirect_to @default_value, notice: 'Default value was successfully updated.' }
        format.json { render :show, status: :ok, location: @default_value }
      else
        format.html { render :edit }
        format.json { render json: @default_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /default_values/1
  # DELETE /default_values/1.json
  def destroy
    @default_value.destroy
    respond_to do |format|
      format.html { redirect_to default_values_url, notice: 'Default value was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_default_value
      @default_value = DefaultValue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def default_value_params
      params.require(:default_value).permit(:invoice_place, :invoice_currency, :tax_rate_id, :invoice_language, :payment_term, :vehicle_requirements, :additional_comments, :arrangements, :client_id, mail_templates_attributes: [:id, :subject, :content, :email_type, :_destroy,])
    end
end

class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]


  # GET /invoices
  # GET /invoices.json
  def index
    @invoices = Invoice.all
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
    @invoice.invoice_items.build
    @invoice.build_invoice_name
    @invoice.invoice_name.month = Date.today.month
    @invoice.invoice_name.year = Date.today.year
    @invoice.invoice_name.number = InvoiceName.get_last_number_for_month(Date.today.month, Date.today.year)
    # @item = @invoice_items.build_item
    # @item2 = @invoice_items.build_item
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)
    #@invoice.items << Item.new(params[:item])
    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to invoices_url, notice: 'Invoice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /invoices/invoice_name/1.json
  def last_invoice_number_for_month
    @invoice_name = InvoiceName.get_last_number_for_month(params[:month], params[:year])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_params
      #params.fetch(:invoice, {})
      params.require(:invoice).permit(
      :date,
      :seller_id,
      :client_id,
      invoice_items_attributes: [ :id, :item_id, :quantity, :unit_price, :_destroy,
        item_attributes:
        [:name, :unit, :id ]
        ],
      invoice_name_attributes: [:number, :month, :year],
      )
    end
end

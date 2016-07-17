class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # GET /invoices
  # GET /invoices.json
  def index
    search_params = { :client_name => params[:client_name], :client_id => params[:client_id],
      :item_id => params[:item_id],
      :date => params[:date], :date_start => params[:date_start],
      :date_stop => params[:date_stop], :invoice_name_number => params[:invoice_name_number],
      :invoice_name_month => params[:invoice_name_month],
      :invoice_name_year => params[:invoice_name_year], :statuses => params[:statuses]
    }

    @client = Client.new
    @invoices = Invoice.joins(:invoice_name).joins(:client).joins(:invoice_items).search(search_params).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 30)
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "faktura",   # Excluding ".pdf" extension.
               encoding: "UTF-8"
      end
      format.json
    end
  end

  # GET /invoices/new
  def new
    @client = Client.new
    @client.build_address
    @client.build_contact

    @item = Item.new

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
    @client = Client.new
    @client.build_address
    @client.build_contact

    @item = Item.new
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
        @client = Client.new
        @client.build_address
        @client.build_contact

        @item = Item.new
        format.html { render :new, :locals => { :client => @client } }
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
        @client = Client.new
        @client.build_address
        @client.build_contact

        @item = Item.new
        format.html { render :edit, :locals => { :client => @client } }
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

  def update_multiple
    if params[:commit] == 'Aktualizuj status'
      Invoice.where(id: params[:invoice_ids]).update_all(["status=?", params[:status]])
      redirect_to invoices_path
    elsif params[:commit] == 'Pobierz faktury'
      require 'zip'
      @invoices = Invoice.where(id: params[:invoice_ids])
      stringio = Zip::OutputStream.write_buffer do |zio|
        @invoices.each do |invoice|
          #create and add a pdf file for this record
          dec_pdf = render_to_string :pdf => "#{invoice.get_file_name}.pdf", :template => '/invoices/show.pdf.erb', :locals => { :@invoice => invoice}, encoding: "UTF-8"

          zio.put_next_entry("#{invoice.get_file_name}.pdf")
          zio << dec_pdf
        end
      end
      stringio.rewind
      #just using variable assignment for clarity here
      binary_data = stringio.sysread
      send_data(binary_data, :type => 'application/zip', :filename => "faktury.zip")
    end
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
      :place,
      :seller_id,
      :client_id,
      :client_name,
      :client_street,
      :client_country,
      :client_email,
      :client_phone,
      :status,
      :currency_rate_table_name,
      :currency_rate_name,
      :currency_rate,
      :client_zip,
      :client_city,
      :net_price,
      :value_added_tax,
      :total_selling_price,
      :total_price_in_words,
      invoice_items_attributes: [ :id, :item_id, :quantity, :unit_price, :net_price, :value_added_tax, :total_selling_price, :tax_rate, :_destroy,
        item_attributes:
        [:name, :unit, :id ]
        ],
      invoice_name_attributes: [:number, :month, :year],
      )
    end

    def sort_column
      # Client.joins(:address).joins(:contact).column_names.include?(params[:sort]) ? params[:sort] : "name"
      if params[:sort].present?
        params[:sort]
      else
        "date"
      end
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end

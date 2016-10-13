class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # GET /invoices
  # GET /invoices.json
  def index
    search_params = params

    @client = Client.new
    @invoices = Invoice.joins(:invoice_name).joins(:client).joins(:groups).where('groups.id = ?', @group.id)
    @invoices = @invoices.search(search_params).order(sort_column + " " + sort_direction)
    @invoices = @invoices.paginate(:page => params[:page], :per_page => 30)
    authorize @invoices
    respond_to do |format|
      format.html
      if params[:q].present?
        @invoices = @invoices.where("invoice_names.number = ?", params[:q]).limit(15)
      end
      format.json
    end
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    authorize @invoice
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
    @client.contact.emails.build

    @item = Item.new

    @invoice = Invoice.new
    @invoice.build_invoice_name
    @invoice.invoice_name.month = Date.today.month
    @invoice.invoice_name.year = Date.today.year
    @invoice.invoice_name.number = InvoiceName.get_last_number_for_date(DateTime.now.strftime('%F'), @group.id)
    @invoice.seller_id = @group.default_value.client_id

    if params['kind'] == 'correction'
      @invoice.invoice_item_corrections.build
      @invoice.kind = 'correction'
    else
      @invoice.invoice_items.build
      if params['kind'] == 'proforma'
        @invoice.kind = 'proforma'
      else
        @invoice.kind = 'vat'
      end
    end

    authorize @invoice
  end

  def new_correction
    @client = Client.new
    @client.build_address
    @client.build_contact
    @client.contact.emails.build

    @item = Item.new

    @invoice_to_correct = Invoice.find(params[:id])

    @invoice = Invoice.new
    @invoice.build_invoice_name
    @invoice.invoice_name.group = @group
    @invoice.invoice_name.month = Date.today.month
    @invoice.invoice_name.year = Date.today.year
    @invoice.invoice_name.number = InvoiceName.get_last_number_for_date(DateTime.now.strftime('%F'), @group.id, 'correction')
    @invoice.kind = 'correction'
    @invoice.invoice_to_correct = @invoice_to_correct
    @invoice.client = @invoice_to_correct.client
    @invoice.seller = @invoice_to_correct.seller
    @invoice.client_name = @invoice_to_correct.client_name
    @invoice.client_street = @invoice_to_correct.client_street
    @invoice.client_zip = @invoice_to_correct.client_zip
    @invoice.client_city = @invoice_to_correct.client_city
    @invoice.client_country = @invoice_to_correct.client_country
    @invoice.client_email = @invoice_to_correct.client_email
    @invoice.client_phone = @invoice_to_correct.client_phone
    @invoice.client_nip = @invoice_to_correct.client_nip
    @invoice.invoice_language = @invoice_to_correct.invoice_language
    @invoice.deadline = @invoice_to_correct.deadline
    @invoice.currency_rate_name = @invoice_to_correct.currency_rate_name
    @invoice.currency_rate = @invoice_to_correct.currency_rate
    @invoice.currency_rate_table_name = @invoice_to_correct.currency_rate_table_name
    @invoice.currency_rate_date = @invoice_to_correct.currency_rate_date
    @invoice.net_price = Money.new(0, @invoice_to_correct.net_price_currency)
    @invoice.value_added_tax = Money.new(0, @invoice_to_correct.net_price_currency)
    @invoice.total_selling_price = Money.new(0, @invoice_to_correct.net_price_currency)
    @invoice_to_correct.invoice_items.each do |invoice_item|
      invoice_item_correction = InvoiceItemCorrection.new
      invoice_item_correction.invoice = @invoice
      invoice_item_correction.item = invoice_item.item
      invoice_item_correction.item_name = invoice_item.item.name
      invoice_item_correction.item_name_correction = invoice_item.item.name
      invoice_item_correction.quantity = invoice_item.quantity
      invoice_item_correction.quantity_correction = invoice_item_correction.quantity
      invoice_item_correction.quantity_difference = 0
      invoice_item_correction.tax_rate = invoice_item.tax_rate
      invoice_item_correction.tax_rate_correction = invoice_item.tax_rate
      invoice_item_correction.unit_price = invoice_item.unit_price
      invoice_item_correction.unit_price_correction = invoice_item.unit_price
      invoice_item_correction.unit_price_difference = Money.new(0, @invoice.net_price_currency )
      invoice_item_correction.value_added_tax = invoice_item.value_added_tax
      invoice_item_correction.value_added_tax_correction = invoice_item.value_added_tax
      invoice_item_correction.value_added_tax_difference = Money.new(0, @invoice.net_price_currency )
      invoice_item_correction.net_price = invoice_item.net_price
      invoice_item_correction.net_price_correction = invoice_item.net_price
      invoice_item_correction.net_price_difference = Money.new(0, @invoice.net_price_currency )
      invoice_item_correction.total_selling_price = invoice_item.total_selling_price
      invoice_item_correction.total_selling_price_correction = invoice_item.total_selling_price
      invoice_item_correction.total_selling_price_difference = Money.new(0, @invoice.net_price_currency )
      @invoice.invoice_item_corrections << invoice_item_correction
    end

    authorize @invoice
  end

  def new_invoice_from_transport_orders
    @client = Client.new
    @client.build_address
    @client.build_contact
    @client.contact.emails.build

    @item = Item.new

    @invoice = Invoice.new
    @invoice.build_invoice_name
    @invoice.invoice_name.group = @group
    @invoice.invoice_name.month = Date.today.month
    @invoice.invoice_name.year = Date.today.year
    @invoice.invoice_name.number = InvoiceName.get_last_number_for_date(DateTime.now.strftime('%F'), @group.id)
    @invoice.kind = 'vat'

    transport_order_ids = params[:transport_order_ids]
    transport_order_ids.each do |transport_order_id|
      transport_order = TransportOrder.find(transport_order_id)
      if transport_order.item.present?
        invoice_item = InvoiceItem.new()
        invoice_item.item_id = transport_order.item.id
        invoice_item.quantity = 1
        invoice_item.unit_price = transport_order.item.unit_price
        invoice_item.tax_rate = transport_order.client.tax_rate
        @invoice.invoice_items << invoice_item
      end
    end
    transport_order = TransportOrder.find(params[:transport_order_ids][0])
    @invoice.client = transport_order.client
    @invoice.seller = transport_order.seller
    @invoice.client_name = transport_order.client_name
    @invoice.client_street = transport_order.client_street
    @invoice.client_zip = transport_order.client_zip
    @invoice.client_city = transport_order.client_city
    @invoice.client_nip = transport_order.client_nip
    @invoice.client_country = transport_order.client_country
    @invoice.sell_date = transport_order.unloading_places.last.date
    @invoice.invoice_language = transport_order.client.invoice_language
    @invoice.deadline = transport_order.client.payment_term
    @invoice.invoice_exchange_currency = transport_order.client.invoice_currency
    authorize @invoice
  end

  # GET /invoices/1/edit
  def edit
    @client = Client.new
    @client.build_address
    @client.build_contact

    @item = Item.new
    authorize @invoice
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)
    authorize @invoice
    #@invoice.items << Item.new(params[:item])
    respond_to do |format|
      if @invoice.save
        @group.add(@invoice)
        @group.add(@invoice.invoice_name)
        update_client_info(@invoice, invoice_params)
        # update transport_order info
        @invoice.items.each do |item|
          if item.transport_order.present?
            transport_order = item.transport_order
            transport_order.invoice_id = @invoice.id
            transport_order.save
          end
        end
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
    authorize @invoice
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
    authorize @invoice
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to invoices_url, notice: 'Invoice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /invoices/invoice_name/1.json
  def last_invoice_number_for_date
    @invoice_number = InvoiceName.get_last_number_for_date(params[:date], @group.id, params[:kind])
    @invoice_prefix = InvoiceName.get_prefix_for_kind(params[:kind])
  end

  def update_multiple
    authorize @invoice
    if params[:commit] == 'Aktualizuj status'
      Invoice.where(id: params[:invoice_ids]).update_all(["status=?", params[:status]])
      redirect_to invoices_path
    elsif params[:commit] == 'Pobierz faktury'
      require 'zip'
      @invoices = Invoice.where(id: params[:invoice_ids])
      stringio = Zip::OutputStream.write_buffer do |zio|
        @invoices.each do |invoice|
          #create and add a pdf file for this record
          dec_pdf = render_to_string :pdf => "#{invoice.get_file_name}.pdf",
          :template => '/invoices/show.pdf.erb',
          :locals => { :@invoice => invoice}, encoding: "UTF-8"

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
      :kind,
      :date,
      :sell_date,
      :deadline,
      :place,
      :seller_id,
      :client_id,
      :client_name,
      :client_street,
      :client_country,
      :client_email,
      :client_phone,
      :client_nip,
      :invoice_to_correct_id,
      :correction_cause,
      :status,
      :invoice_language,
      :invoice_exchange_currency,
      :currency_rate_table_name,
      :currency_rate_name,
      :currency_rate_date,
      :currency_rate,
      :client_zip,
      :client_city,
      :net_price,
      :net_price_currency,
      :value_added_tax,
      :value_added_tax_currency,
      :total_selling_price,
      :total_selling_price_currency,
      :total_price_in_words,
      :total_price_in_words_currency,
      :transport_order_ids,
      invoice_items_attributes: [ :id, :item_id, :quantity, :unit_price,
        :unit_price_currency, :net_price, :net_price_currency, :value_added_tax,
        :value_added_tax_currency, :total_selling_price,
        :total_selling_price_currency, :tax_rate_id, :_destroy,
        item_attributes:
          [:name, :unit, :id ]
      ],
      invoice_item_corrections_attributes: [ :id, :item_id, :quantity, :quantity_correction, :quantity_difference,
          :item_name, :item_name_correction,
	        :unit_price, :unit_price_correction, :unit_price_difference,
	        :unit_price_currency, :unit_price_correction_currency, :unit_price_difference_currency,
	        :net_price, :net_price_correction, :net_price_difference,
	        :net_price_currency, :net_price_correction_currency, :net_price_difference_currency,
	        :value_added_tax, :value_added_tax_correction,:value_added_tax_difference,
	        :value_added_tax_currency, :value_added_tax_correction_currency, :value_added_tax_difference_currency,
	        :total_selling_price, :total_selling_price_correction, :total_selling_price_difference,
	        :total_selling_price_currency, :total_selling_price_correction_currency, :total_selling_price_difference_currency,
	        :tax_rate_id, :tax_rate_correction_id,
	        :_destroy,
          item_attributes:
            [:name, :unit, :id ]
            ],
      invoice_name_attributes: [:prefix, :number, :month, :year, :group_id],
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

    def update_client_info(invoice, invoice_params)
      client = invoice.client
      if client.name != invoice_params[:client_name]
        client.name = invoice_params[:client_name]
      end
      if client.address.street != invoice_params[:client_street]
        client.address.street = invoice_params[:client_street]
      end
      if client.address.zip != invoice_params[:client_zip]
        client.address.zip = invoice_params[:client_zip]
      end
      if client.address.city != invoice_params[:client_city]
        client.address.city = invoice_params[:client_city]
      end
      if client.address.country != invoice_params[:client_country]
        client.address.country = invoice_params[:client_country]
      end
      if client.contact.email != invoice_params[:client_email]
        client.contact.email = invoice_params[:client_email]
      end
      if client.contact.phone1 != invoice_params[:client_phone]
        client.contact.phone1 = invoice_params[:client_phone]
      end
      client.save
    end
end

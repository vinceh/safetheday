class AdminsController < ApplicationController
  protect_from_forgery

  layout "admin"

  before_filter :authenticate_admin!

  def pending_shipments
    @invoices = Invoice.where(:shipped_on => nil).where("amount > 0").order("created_at ASC")
  end

  def shipped_subscription
    @invoices = Invoice.where("invoices.shipped_on IS NOT NULL").where("amount > 0").order("shipped_on DESC")
  end

  def get_labels
    require 'spreadsheet'
    Spreadsheet.client_encoding = 'UTF-8'

    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    sheet.name = 'Shipping Labels'

    # Setting the titles
    titles = sheet.row(0)
    titles.push("First Name")
    titles.push("Last Name")
    titles.push("Address Line 1")
    titles.push("Address Line 2")
    titles.push("City")
    titles.push("Province")
    titles.push("Country")
    titles.push("Postal Code")

    # Write the data
    x = 1
    params[:items].split(",").each do |id|
      row = sheet.row(x)

      invoice = Invoice.find(id.to_i)
      user = invoice.user

      if user.shipping_same
        row.push(invoice.user.billing_first_name)
        row.push(invoice.user.billing_last_name)
        row.push(invoice.user.billing_address_one)
        row.push(invoice.user.billing_address_two)
        row.push(invoice.user.billing_city)
        row.push(invoice.user.billing_state)
        row.push(invoice.user.billing_country)
        row.push(invoice.user.billing_zipcode)
      else
        row.push(invoice.user.shipping_first_name)
        row.push(invoice.user.shipping_last_name)
        row.push(invoice.user.shipping_address_one)
        row.push(invoice.user.shipping_address_two)
        row.push(invoice.user.shipping_city)
        row.push(invoice.user.shipping_state)
        row.push(invoice.user.shipping_country)
        row.push(invoice.user.shipping_zipcode)
      end

      x = x + 1
    end

    data = StringIO.new ''
    book.write data

    # Send it back to the client as an attachment
    send_data data.string, :type => 'application/excel', :disposition => 'attachment', :filename => 'labels.xls'
  end

  def bulk_mark
    params[:items].split(",").each do |id|
      invoice = Invoice.find(id.to_i)
      invoice.mark_shipped
    end

    flash[:notice] = "Shipments Marked Successfully"

    redirect_to :action => :pending_shipments
  end

  def mark_shipped
    invoice = Invoice.find(params[:id])
    invoice.mark_shipped

    flash[:notice] = "Shipment Marked Successfully"

    redirect_to :action => :pending_shipments
  end
end

class AdminsController < ApplicationController
  protect_from_forgery

  layout "admin"

  before_filter :authenticate_admin!

  def pending_shipments
    @invoices = Invoice.where(:shipped_on => nil).order("created_at ASC")
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

    # Write the data
    x = 1
    params[:items].split(",").each do |id|
      row = sheet.row(x)

      invoice = Invoice.find(id.to_i)
      user = invoice.user

      if user.shipping_same
        row.push(invoice.user.billing_first_name)
      else
        row.push(invoice.user.shipping_first_name)
      end

      x = x + 1
    end

    data = StringIO.new ''
    book.write data

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

  def shipped_subscription
    @invoices = Invoice.where("invoices.shipped_on IS NOT NULL").order("shipped_on DESC")
  end
end

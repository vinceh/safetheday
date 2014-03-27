class AdminsController < ApplicationController
  protect_from_forgery

  layout "admin"

  before_filter :authenticate_admin!

  def pending_shipments
    @pending = PendingShipment.where(:shipped_on => nil)
  end

  def shipped_subscription
    @shipped = PendingShipment.where("pending_shipments.shipped_on IS NOT NULL")
  end

  def get_labels
    require 'spreadsheet'
    Spreadsheet.client_encoding = 'UTF-8'

    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    sheet.name = 'Shipping Labels'

    # Setting the titles
    titles = sheet.row(0)
    titles.push("FirstName")
    titles.push("LastName")
    titles.push("Address1")
    titles.push("Address2")
    titles.push("City")
    titles.push("State")
    titles.push("PostalCode")
    titles.push("Country/Region")


    # Write the data
    x = 1
    params[:items].split(",").each do |id|
      row = sheet.row(x)

      invoice = PendingShipment.find(id.to_i).invoice
      user = invoice.user

      if user.shipping_same
        row.push(invoice.user.billing_first_name)
        row.push(invoice.user.billing_last_name)
        row.push(invoice.user.billing_address_one)
        row.push(invoice.user.billing_address_two)
        row.push(invoice.user.billing_city)
        row.push(invoice.user.billing_state)
        row.push(invoice.user.billing_zipcode)
        row.push(friendly_country(invoice.user.billing_country))
      else
        row.push(invoice.user.shipping_first_name)
        row.push(invoice.user.shipping_last_name)
        row.push(invoice.user.shipping_address_one)
        row.push(invoice.user.shipping_address_two)
        row.push(invoice.user.shipping_city)
        row.push(invoice.user.shipping_state)
        row.push(invoice.user.shipping_zipcode)
        row.push(friendly_country(invoice.user.shipping_country))
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
      shipment = PendingShipment.find(id.to_i)
      shipment.mark_shipped
    end

    flash[:notice] = "Shipments Marked Successfully"

    redirect_to :action => :pending_shipments
  end

  def mark_shipped
    shipment = PendingShipment.find(params[:id])
    shipment.mark_shipped

    flash[:notice] = "Shipment Marked Successfully"

    redirect_to :action => :pending_shipments
  end

  def subs
    @subs = Subscription.all
  end

  def taxes
    @taxes = Tax.all
  end

  def invoices
    @invoices = Invoice.all
  end

  def users
    @users = User.where(inactive: false).all
  end

  def blog
    @posts = Post.all
  end

  def new_post
    @post = Post.new
  end

  private

  def friendly_country(shorthand)
    case shorthand
      when "CA"
        return "Canada"
      when "US"
        return "United States"
    end
  end
end

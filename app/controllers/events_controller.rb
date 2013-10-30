class EventsController < ApplicationController
  protect_from_forgery

  def stripe_event
    eventJSON = JSON.parse(request.body.read)

    id = eventJSON['id']
    if id
      event = Stripe::Event.retrieve(id)

      case event.type
        when 'invoice.payment_succeeded'
          response = event.data.object
          user = User.find_by_stripe_customer_id(response.customer)
          user.paid = true
          user.save!

          invoice = Invoice.new
          invoice.user = user
          invoice.stripe_invoice_id = response.id
          invoice.amount = response.total
          invoice.stripe_charge_id = response.charge
          invoice.save!

          UserMailer.invoice(user).deliver
        when 'invoice.payment_failed'
          response = event.data.object
          user = User.find_by_stripe_customer_id(response.customer)
          user.paid = false
          user.save!
        when 'charge.succeeded'
          response = event.data.object
          invoice = Invoice.find_by_stripe_charge_id(response.id)
          invoice.fee = response.fee
          invoice.save!
      end
    end

    render :json => {:success => true}
  end
end

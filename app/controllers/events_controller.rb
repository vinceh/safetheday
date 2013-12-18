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
          invoice.currency = response.currency
          invoice.subscription_id = response.lines.data[0].plan.id
          invoice.save!

          ch = Stripe::Charge.retrieve(invoice.stripe_charge_id)
          meta = {}
          user.regional_subscription.taxes.each do |t|
            meta[t.shorthand] = t.percentage
          end
          ch.metadata = meta
          ch.save

          UserMailer.invoice(user, invoice).deliver
        when 'invoice.payment_failed'
          response = event.data.object
          user = User.find_by_stripe_customer_id(response.customer)
          user.paid = false
          user.save!
        when 'charge.succeeded'
          response = event.data.object
          invoice = Invoice.find_by_stripe_charge_id(response.id)
          invoice.stripe_fee = response.fee
          invoice.save!
      end
    end

    render :json => {:success => true}
  end
end

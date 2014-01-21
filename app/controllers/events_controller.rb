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

          if !response.discount
            ch = Stripe::Charge.retrieve(invoice.stripe_charge_id)
            meta = {}
            user.regional_subscription.taxes.each do |t|
              meta[t.shorthand] = t.percentage
            end
            ch.metadata = meta
            ch.save
          else
            invoice.free_month = true
            invoice.save!
          end
        when 'invoice.payment_failed'
          response = event.data.object
          user = User.find_by_stripe_customer_id(response.customer)
          user.paid = false
          user.save!
        when 'customer.subscription.created'
          response = event.data.object
          user = User.find_by_stripe_customer_id(response.customer)
          UserMailer.subscribed(user, request).deliver
      end
    end

    render :json => {:success => true}
  end
end

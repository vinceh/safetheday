class EventsController < ApplicationController
  protect_from_forgery

  def stripe_event
    eventJSON = JSON.parse(request.body.read)

    id = eventJSON['id']
    if id
      event = Stripe::Event.retrieve(id)

      case event.type
        when 'invoice.created'
          response = event.data.object

          if !response.closed
            user = User.find_by_stripe_customer_id(response.customer)

            Stripe::InvoiceItem.create(
              :customer => response.customer,
              :amount => user.calculate_tax,
              :currency => response.currency,
              :invoice => response.id
            )
          end
        when 'invoice.payment_succeeded'
          response = event.data.object
          user = User.find_by_stripe_customer_id(response.customer)
          user.paid = true
          user.save!

          invoice = Invoice.new
          invoice.user = user
          invoice.stripe_invoice_id = response.id
          invoice.amount = response.amount_due
          invoice.stripe_charge_id = response.charge
          invoice.currency = response.currency
          invoice.subscription_id = response.lines.data[0].plan.id

          invoice.save!

          PendingShipment.create_from_invoice(invoice)

          if response.discount && response.discount.coupon.percent_off == 100
            invoice.free_month = true
            invoice.save!

            if user.current_free_months > 0
              user.give_pending_free_month
            end
          else
            ch = Stripe::Charge.retrieve(invoice.stripe_charge_id)
            meta = {}
            user.taxes.each do |t|
              meta[t.shorthand] = t.percentage
            end
            ch.metadata = meta
            ch.save
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

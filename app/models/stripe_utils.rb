class StripeUtils
  def self.discount_for_coupon(coupon_id)
    discount = [0,0]

    begin
      c = Stripe::Coupon.retrieve(coupon_id)

      if c.valid
        discount[0] = c.amount_off
        discount[1] = c.percent_off
      end
    rescue
    end

    discount
  end
end
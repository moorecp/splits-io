class SubscriptionsController < ApplicationController
  before_action :set_subscriptions, only: %i[destroy]

  SILVER = {
    product: ENV['STRIPE_SILVER_PRODUCT_ID'],
    monthly_plan: ENV['STRIPE_SILVER_MONTHLY_PLAN_ID']
  }
  GOLD = {
    product: ENV['STRIPE_GOLD_PRODUCT_ID'],
    monthly_plan: ENV['STRIPE_GOLD_MONTHLY_PLAN_ID']
  }

  def index
  end

  def show
  end

  def destroy
    @subscriptions.find_each do |subscription|
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      Stripe::Subscription.update(
        subscription.stripe_subscription_id,
        cancel_at_period_end: true,
      )

      redirect_to(
        root_path,
        notice: 'Subscription set to not renew. Your subscription will appear active until your next billing renew date, when it will be canceled instead of charged.'
      )
    end

    # We don't actually revoke the subscription on our end here, because the user might have time left in their month.
    # We will revoke those features via Stripe's customer.subscription.deleted webhook, which only fires at the end of
    # the billing period after cancellation.
  end

  private

  def set_subscriptions
    @subscriptions = current_user.subscriptions.active
  end
end

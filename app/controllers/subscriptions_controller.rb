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
    end
    # Set canceled_at now; ended_at will be set by a Stripe webhook when the month runs out
    @subscriptions.update_all(canceled_at: Time.now.utc)

    head :no_content
  end

  private

  def set_subscriptions
    @subscriptions = current_user.subscriptions.active
  end
end

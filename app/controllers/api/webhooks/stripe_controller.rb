class Api::Webhooks::StripeController < ApplicationController
  before_action :set_event, only: %i[create]
  before_action :set_subscriptions, only: %i[create]

  def create
    case type
    when 'checkout.session.completed'
      @subscriptions.update_all(canceled_at: Time.now.utc)
      Subscription.create(
        stripe_session_id: @event.id,
        stripe_plan_id: @event.plan.display_items[0].plan.id,
        stripe_subscription_id: @event.subscription,
        stripe_payment_intent_id: @event.payment_intent,
        stripe_customer_id: @event.customer,
      )
    when 'customer.subscription.deleted'
      @subscriptions.update_all(canceled_at: Time.now.utc)
    end
  end

  private

  def set_event
    @event = Stripe::Webhook.construct_event(
      request.body,
      request.headers['HTTP_STRIPE_SIGNATURE'],
      ENV['STRIPE_WEBHOOK_SECRET'],
    )
  end

  def set_subscriptions
    @subscriptions = Subscription.where(stripe_customer_id: @event.customer)
  end
end

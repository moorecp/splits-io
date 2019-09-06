class Subscription < ActiveRecord::Base
  belongs_to :user

  scope :active, -> { where(ended_at: nil) }
  scope :canceled, -> { where.not(canceled_at: nil) }
  scope :silver, -> { where(stripe_plan_id: ENV['STRIPE_SILVER_PLAN_ID']) }
  scope :gold,   -> { where(stripe_plan_id: ENV['STRIPE_GOLD_PLAN_ID']) }

  def type
    case stripe_plan_id
    when ENV['STRIPE_SILVER_PLAN_ID']
      :silver
    when ENV['STRIPE_GOLD_PLAN_ID']
      :gold
    end
  end

  def canceled?
    canceled_at.present?
  end

  def ended?
    ended_at.present?
  end
end

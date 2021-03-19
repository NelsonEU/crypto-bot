class Coin < ApplicationRecord
  belongs_to :user

  has_many :recurring_alert_lines

  scope :for_user, ->(user) { where(user: user) }

  def last_value
    quantity * last_price
  end

  def formatted_quantity
    return 0 if quantity.zero?

    quantity
  end

  #
  # Utilities
  #
  def variation(old_price)
    return 0 if old_price.nil? || old_price.zero?

    100 * (last_price - old_price) / old_price
  end
end

class ShipOrderJob < ApplicationJob
  queue_as :default

  def perform(order, **params)
    OrderMailer.shipped(order).deliver_later
  end
end

class ResourceClick < ApplicationRecord

  validates :user_id, :resource_id, :count, presence: true

  validates :count, numericality: {greater_than: 0}

  belongs_to :resource
  belongs_to :user
end

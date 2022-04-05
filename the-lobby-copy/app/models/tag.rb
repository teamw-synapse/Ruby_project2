# frozen_string_literal: true

class Tag < ApplicationRecord
  PLACEHOLDER_TEXT = "Enter Tags"

  has_and_belongs_to_many :resources
  validates :name, presence: true, uniqueness: true


end

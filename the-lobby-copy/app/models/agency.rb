# frozen_string_literal: true

class Agency < ApplicationRecord
  attr_accessor :branding_template_id

  validates :name, presence: true
  has_many :agencies_resources, dependent: :destroy
  has_many :resources, through: :agencies_resources
  has_one :agency_branding
  has_one :branding, through: :agency_branding 

  #after_save :add_brand_to_agency

  #private

  #def add_brand_to_agency
  #  t_branding = Branding.find_by(id: branding_template_id)
  #  if t_branding.blank?
  #    self.branding.destroy if self.branding.present?
  #  else
  #    if self.branding.present?
  #      existing_branding = self.branding
  #      existing_branding.logo = t_branding.logo.blob if t_branding.logo.attached?
  #      existing_branding.font = t_branding.font
  #      existing_branding.primary_color = t_branding.primary_color
  #      existing_branding.secondary_color = t_branding.secondary_color
  #      existing_branding.name = t_branding.name + " |"
  #      existing_branding.save!
  #    else
  #      agency_branding = t_branding.dup
  #      agency_branding.assign_attributes(agency_id: id, name: t_branding.name.to_s + " |")
  #      agency_branding.logo = t_branding.logo.blob if t_branding.logo.attached?
  #      agency_branding.default = false
  #      agency_branding.save!
  #    end
  #  end
  #end

end

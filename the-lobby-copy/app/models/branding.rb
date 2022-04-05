# frozen_string_literal: true

class Branding < ApplicationRecord
  has_one_attached :logo
  has_many :agency_brandings, dependent: :destroy
  has_many :agencies, through: :agency_brandings

  validates :name, :logo, presence: true
  validates :font_url, format: { with: Resource::HTTP_URL_REGEXP }, if: lambda {|o| o.font_url.present?}
  validate :default_can_only_be_one, if: lambda {|o| o.will_save_change_to_default? && o.default? }
  validate :default_branding_no_agency, if: lambda {|o| o.default?}
  validate :only_one_branding_for_one_agency, if: lambda {|o| o.agency_brandings.present?}
  validate :logo_present?

  def self.default
    find_by(default: true)
  end

  private

  def default_can_only_be_one
      errors.add(:default, "Default branding can only be one") if Branding.where(default: true).where.not(id: id).count == 1
  end

  def default_branding_no_agency
    errors.add(:default, "Default branding cannot be assigned to an agency") if default? && agency_brandings.present?
  end

  def only_one_branding_for_one_agency
    agency_name = ""
    agency_brandings.each do |agency_branding|
      agency_id = agency_branding.agency_id
      branding = Agency.where(id: agency_id).last.branding
      if branding.present? && (branding.id != id) 
        agency_name += " #{Agency.find(agency_id).name}," 
      end
    end
    errors.add(:agency_ids, "Branding for #{agency_name.chomp(',')} already exists") if agency_name.length > 0 
  end

  def logo_present?
    self.errors.add(:logo, "Please select an logo") unless logo.attached?
  end

end

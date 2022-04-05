# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :trackable, :omniauthable, omniauth_providers: %i[openam]

  validates :email, presence: true, uniqueness: true, format: Devise.email_regexp
  validates :tbwa_uid, presence: true, uniqueness: true, unless: :added_as_agency_admin?

  has_many :roles, dependent: :destroy
  accepts_nested_attributes_for :roles, allow_destroy: true

  has_many :resource_clicks, dependent: :destroy
  has_many :resource_template_usages, dependent: :destroy

  def password_required?
    false
  end

  def agency
    agency_id = roles.find_by(name: 'user').try(:agency_id)
    agency = Agency.find agency_id if agency_id
  end

  def agency_admin?
    agency_admin_roles.count > 0
  end

  def global_admin?
    roles.where(name: 'global_admin').count > 0
  end

  def admin?
    global_admin? || agency_admin?
  end

  def agency_admin_roles
    roles.where(name: 'agency_admin').where.not(agency_id: nil)
  end

  def is_agency_admin_of?(agency)
    agency_admin_roles.where(agency_id: agency.id).count > 0
  end

  def add_as_admin_of(agency)
    roles.create(name: "agency_admin", agency_id: agency.id)
  end

  def remove_as_admin_of(agency)
    agency_admin_roles.where(agency_id: agency.id).destroy_all
  end

end

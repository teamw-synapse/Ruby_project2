# frozen_string_literal: true

class AdminAuthorization < ActiveAdmin::AuthorizationAdapter

  def authorized?(_action, subject = nil)
    # actions - :read, :create, :update, :destroy
    return false if !user.admin?
    case subject
    when ActiveAdmin::Page
      if subject.name == "Highlights"
        user.global_admin?
      else
        return true
      end
    when normalized(Agency)
      return false unless user.global_admin?
      return true if _action == :read
      return true if _action == :update_agency_admins && user.global_admin?


    when Resource
      return true if _action == :read || user.global_admin?
      return true if _action == :edit && user.agency_admin? && subject.global?
      return true if _action == :update && user.agency_admin?
      return false if subject.agencies_resources.blank? || subject.highlight? || subject.global?
      subject.agencies_resources.each do |ar|
        return false if !user.is_agency_admin_of?(ar.agency)
      end


    when Branding
      return true if user.global_admin?
      return false if subject.agencies.blank? && (_action == :update || _action == :destroy || _action == :read)
      return false if _action == :create_branding && !user.global_admin? && subject.agencies.blank?
      #return true if subject.agency_id.blank? && _action == :create
      subject.agency_brandings.each do |ab|
        user.is_agency_admin_of?(Agency.find(ab.agency_id))
      end
    when normalized(Tag)
      return true
    when normalized(User)
      return false unless user.global_admin?
      _action == :read
    when normalized(ResourceClick)
      return true if user.global_admin? && _action == :read
    else
      true
    end
  end

  def scope_collection(collection, _action = Auth::READ)
    if collection == Agency
      if user.global_admin?
        return collection
      else
        admin_of_agencies = user.roles.where(name: "agency_admin").pluck(:agency_id)
        return collection.where(id: admin_of_agencies)
      end
    end

    if collection == Branding
      if user.global_admin?
        return collection
      else
        admin_of_agencies = user.roles.where(name: "agency_admin").pluck(:agency_id)
        return collection.joins(:agency_brandings).where(agency_brandings: {agency_id: admin_of_agencies})
      end
    end

    if collection == Resource
      if user.global_admin?
        return collection
      else
        admin_of_agencies = user.roles.where(name: "agency_admin").pluck(:agency_id)
        agency_resource_ids = collection.joins(:agencies_resources).where(agencies_resources: {agency_id: admin_of_agencies}).pluck(:id)
        global_resource_ids = collection.where(global: true).pluck(:id)
        return collection.where(id: agency_resource_ids + global_resource_ids)
      end
    end

    if collection == User
      if user.global_admin?
        return collection
      else
        admin_of_agencies = user.roles.where(name: "agency_admin").pluck(:agency_id)
        return collection.includes(:roles).where(roles: {name: "user", agency_id: admin_of_agencies})
      end
    end

    if collection == Tag
      return collection
    end

    return collection

  end

end

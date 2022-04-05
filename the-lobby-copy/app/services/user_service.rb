module UserService
  class << self
    def create_or_update_user user_info, agency = nil
      user = User.find_by(tbwa_uid: user_info['tbwaUid']) || User.find_by(email: user_info['mail'], added_as_agency_admin: true)
      if user
        agency = find_user_agency user_info unless agency.present?
        if user.added_as_agency_admin?
          user.update(first_name: user_info['givenName'], last_name: user_info['sn'], tbwa_uid: user_info['tbwaUid'])
        end
        manage_roles user, user_info, agency
      else
        user = create_user user_info
      end
      user
    end

    def create_user user_info
      user = User.new
      user.tbwa_uid = user_info['tbwaUid']
      user.email = user_info['mail']
      user.first_name = user_info['givenName']
      user.last_name = user_info['sn']
      user_dn = user_info['dn']
      agency = find_user_agency user_info
      user.roles.build(agency_id: agency.id, name: "user")
      user.roles.build(name: "global_admin") if member_of_global user_info
      user.save
      user
    end

    def manage_roles user, user_info, agency
      user.email = user_info['mail'] if user.email.blank? || (user.email != user_info['mail'])
      if member_of_global user_info
        user.roles.build(name: "global_admin") if !user.global_admin?
      else
        user.roles.where(name: "global_admin").destroy_all
      end
      user_role = user.roles.where(name: "user").last
      if user_role.present?
        user_role.agency_id = agency.id
        user_role.save
      else
        user.roles.build(agency_id: agency.id, name: "user")
      end
      user.save
    end

    def find_user_agency user_info
      user_agency_dn_arr = user_info['dn'].split(',')
      user_agency_name = user_agency_dn_arr[1].split('=')[1]
      user_agency_city = user_agency_dn_arr[2].split('=')[1]
      user_agency_country = user_agency_dn_arr[3].split('=')[1]
      user_agency_region = user_agency_dn_arr[4].split('=')[1]
      user_agency_pdon = user_info['company']
      Agency.find_by(name: user_agency_name, city: user_agency_city, country: user_agency_country, region: user_agency_region, physical_delivery_office_name: user_agency_pdon)
    end

    def member_of_global user_info
      return false if !Rails.env.production? && Settings.skip_global_admin_emails.include?(user_info["mail"])
      user_info['memberOf'].present? && user_info['memberOf'].include?(Role::GLOBAL_ADMIN_MEMBER_OF_STR)
    end
  end
end

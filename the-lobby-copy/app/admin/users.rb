ActiveAdmin.register User do
  menu if: proc{ current_admin_user.global_admin? }

  actions :all, :except => [:destroy]

  permit_params roles_attributes: [:id, :agency_id, :user_id, :name, :_destroy]

  show do
    attributes_table do
      row :id
      row :tbwa_uid
      row :email
      row :first_name
      row :last_name
      row :sign_in_count
      row :global_admin?
      row :added_as_agency_admin
      row :agency
      
      row :created_at
      row :updated_at

      if resource.agency_admin? && !resource.global_admin?
       panel "Agency Admin" do
         table_for resource.roles.where(name: "agency_admin") do
           column {|r| Agency.find(r.agency_id)}
         end
       end
      end
    end
  end

  form title: 'Edit User Agency' do |f|
    f.has_many :roles, new_record: 'Add Admin for Agency', allow_destroy: true do |r|

    end
    f.actions
  end

  collection_action :autocomplete_user_email, method: :get do
    res = HTTParty.get("http://autocomplete.int.factory.tools/v1?email=#{params[:term]}", headers:{ Authorization: "Basic #{Settings.users_autocomplete_token}" })
    users_arr = []
    res.parsed_response.each do |r|
      users_arr << r["email"]
    end
    respond_to do |format|
      format.json {render json: users_arr.to_json}
    end
  end

end

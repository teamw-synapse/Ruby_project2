ActiveAdmin.register Agency do
  menu if: proc{ current_admin_user.global_admin? }
	actions :index, :show

	permit_params :name, :address, :city, :country, :region, :telephone, :url, :logo,
	:branding_template_id

	index do
    selectable_column
    # id_column
		column :name
		column :branding
		column :physical_delivery_office_name
		column :address
		column :city
		column :country
		column :region
		column :telephone
		column :url
		column :created_at
		column :updated_at
		actions
	end

	show do
    attributes_table do
			row :name
			row :branding
			row :physical_delivery_office_name
			row :address
			row :city
			row :country
			row :region
			row :telephone
			row :url
      row :created_at
      row :updated_at
    end
	end


  sidebar :'Add Agency Admin', only: :show, if: proc{current_admin_user.global_admin?} do
		@users = User.where(:id => User.all.pluck(:id) - Role.where(agency_id: params[:id], name: "agency_admin").pluck(:user_id))
		render :partial => "add_admin", :locals =>{ :users => @users }
	end

	sidebar "Remove Agency Admin", only: :show, if: proc{current_admin_user.global_admin?} do
		@agency_admins = User.includes(:roles).where(roles: {name: "agency_admin", agency_id: resource.id})
		render partial: "remove_admin", locals: {agency_admins: @agency_admins}
	end

	member_action :add_agency_admin, method: :post do
		@agency = Agency.find params[:id]
		authorize! :update_agency_admins, @agency

		if params[:ad_email].blank?
			flash[:alert] = "Please select a user to create agency admin"
			redirect_to({action: :show})
		else
			@user = User.find_by(email: params[:ad_email])
      if @user.present? && @user.is_agency_admin_of?(@agency).blank?
				@user.add_as_admin_of(@agency)
				flash[:notice] = "#{@user.email} added as Agency admin"
      elsif @user.present? && @user.is_agency_admin_of?(@agency)
				flash[:notice] = "#{@user.email} is already an Agency admin"
			else
				begin
        	@user = User.create!(email: params[:ad_email], added_as_agency_admin: true)
					@user.add_as_admin_of(@agency)
					flash[:notice] = "#{@user.email} added as Agency admin"
				rescue StandardError => e
					flash[:notice] = "#{e}"
					puts "*"*100
					puts e
					puts "*"*100
				end
			end
			redirect_to({action: :show})
		end
  end

	member_action :remove_agency_admin, method: :post do
		@agency = Agency.find params[:id]
		authorize! :update_agency_admins, @agency

		if params[:user_id].blank?
			flash[:alert] = "Please select a user to Remove as agency admin"
			redirect_to({action: :show})
			return
		end
		@user = User.find params[:user_id]

		if @user.is_agency_admin_of?(@agency)
			@user.remove_as_admin_of(@agency)
			flash[:notice] = "#{@user.email} removed as Agency admin"
			redirect_to({action: :show})
		end
	end

	filter :branding
	filter :name
	filter :physical_delivery_office_name
	filter :city
	filter :country
	filter :region

end

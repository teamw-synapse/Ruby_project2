ActiveAdmin.register Branding do

	permit_params :logo, :name, :font_url, :font_family, :primary_color, :secondary_color, :agency_ids => []
  form do |f|
    f.semantic_errors
    f.inputs "Branding" do
      f.input :name
      f.input :logo, as: :file
      f.input :primary_color
      f.input :secondary_color
      f.input :font_url
      f.input :font_family
			if current_admin_user.global_admin?
        if f.object.default?
  				f.input :default, input_html: {disabled: "disabled"}
        else
          f.input :agency_ids, as: :select, collection: Agency.all.order("LOWER(name)").collect{|agency| ["#{agency.name}, #{agency.city}, #{agency.country}", agency.id]}, multiple: true, label: "Agencies"
        end
      else
        f.input :agency_ids, as: :select, collection: Agency.where(:id => (current_admin_user.agency_admin_roles.pluck(:agency_id))).order("LOWER(name)").collect{|agency| ["#{agency.name}, #{agency.city}, #{agency.country}", agency.id]}, multiple: true, label: "Agencies"
      end
   end
    f.actions
  end

	show do
    attributes_table do
      row :logo do |branding|
        image_tag(branding.logo, width:100,height:80) if branding.logo.attached?
			end
			row :name
			row :primary_color
			row :secondary_color
      row "Agencies" do |branding|
        branding.agencies.map do |agency|
          " " + link_to(agency.name, admin_agency_path(agency))
        end.join(',').html_safe
      end
			row :font_url
      row :font_family
      row :default
      row :created_at
      row :updated_at
    end
	end

	index do
    selectable_column
    # id_column
		column :name
		column :logo do |brand|
			image_tag(brand.logo, width: 20, height: 20) if brand.logo.attached?
    end
    column "Agencies" do |branding|
      branding.agencies.map do |agency|
        " " + link_to(agency.name, admin_agency_path(agency))
      end.join(',').html_safe
    end
		column :primary_color
		column :secondary_color
		column :font_url
    column :font_family
		column :created_at
		column :updated_at
		actions
  end

  filter :name

  controller do
    def create
      @branding = Branding.new(permitted_params[:branding])
      authorize! :create_branding, @branding
      super
    end
  end

end

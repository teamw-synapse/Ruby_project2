  ActiveAdmin.register Resource do
  menu parent: 'Resources', label: 'Resources List', priority: 0
    permit_params :url, :is_local, :title, :description, :position, :global, :highlight, :highlight_position, :username, :password, :template,
    :image, :show_info, :overview, :key_contact, :documentation, :image_cache, agency_ids: []

  collection_action :highlight_sort, method: :patch do
    params[:resource].each_with_index do |id, index|
      Resource.where(id: id).update_all(highlight_position: index+1)
    end
  end

  index do
    selectable_column
    id_column
    column :url
    column :title
    column :description
    column "Agencies" do |resource|
      resource.agencies.map do |agency|
        " " + link_to(agency.name, admin_agency_path(agency))
      end.join(',').html_safe
    end
    column :global
    column :highlight
    column :highlight_position
    column :image do |resource|
      image_tag(resource.image_url.to_s, width: 100, height: 80) if resource.image
    end
    column :username
    column :password
    actions
  end

  filter :global
  filter :highlight
  filter :template
  filter :agencies, :as => :select, collection: proc {(current_admin_user.global_admin? ? Agency.all : Agency.where(id: (current_admin_user.roles.where(name: "agency_admin").pluck(:agency_id)))).map{ |c| [c.name, c.id]}}


  #Resource Show page
  show do
    attributes_table do
      row :title
      row :url
      row :is_local
      row :description
      row "Agencies" do |resource|
        resource.agencies.map do |agency|
          " " + link_to(agency.name, admin_agency_path(agency))
        end.join(',').html_safe
      end
      row :template
      row :global
      row :highlight
      row :highlight_position
      row :image do |resource|
        image_tag(resource.image_url.to_s, width: 100, height: 80) if resource.image
      end
      row "Tags" do |resource|
        resource.tags.map do |tag|
          " " + link_to(tag.name, admin_tag_path(tag))
        end.join(',').html_safe
      end
      row :overview
      row :key_contact
      row :documentation
      row :username
      row :password
      row :created_at
      row :updated_at
    end
  end

  controller do

    def new
      @resource = Resource.new
      @user_agencies = current_admin_user.global_admin? ? Agency.all : Agency.where(id: (current_admin_user.roles.where(name: "agency_admin").pluck(:agency_id)))
      @resource_templates = Resource.templates
      respond_to do |format|
        format.html {render "form", layout: 'active_admin'}
      end
    end

    def edit
      @resource = Resource.find params[:id]
      @resource_templates = Resource.templates
      authorize! :edit, @resource
      @user_agencies = current_admin_user.global_admin? ? Agency.all : Agency.where(id: (current_admin_user.roles.where(name: "agency_admin").pluck(:agency_id)))
      respond_to do |format|
        if @resource.global == true && current_admin_user.agency_admin? && !current_admin_user.global_admin?
          format.html {render "global_resource_as_agency_resource", layout: 'active_admin'}
        else
          format.html {render "form", layout: 'active_admin'}
        end 
      end
    end

    def update
      @resource = Resource.find params[:id]
      resource_img = params[:resource][:template_image]
      if params[:resource][:image].blank?
        @resource.remote_image_url = resource_img
      end
      authorize! :update, @resource
      if params[:resource][:tag_names] == nil
      else
        all_tags = (params[:resource][:tag_names] + "," + params["as_values_resource_tags"]).split(",").compact.uniq.reject{|t| t.blank? || t == Tag::PLACEHOLDER_TEXT}
        resource_tags_name = @resource.tags.pluck(:name)
        tags_to_add = all_tags - resource_tags_name
        tags_to_remove = resource_tags_name - all_tags
        tags_to_add.each do |t|
          tag = Tag.find_or_create_by(name: t)
          @resource.tags << tag if !@resource.tags.include?(tag)
        end
        tags_to_remove.each do |t|
          tag = Tag.find_by(name: t)
          @resource.tags.delete(tag)
        end
      end
      if @resource.update_attributes(permitted_params[:resource])
        redirect_to admin_resource_path(resource), notice: "Resource updated"
      else
        @resource_templates = Resource.templates
        @resource.template_image = params[:resource][:template_image]
        @user_agencies = current_admin_user.global_admin? ? Agency.all : Agency.where(id: (current_admin_user.roles.where(name: "agency_admin").pluck(:agency_id)))
        render :form, layout: "active_admin"
      end
    end

    def create
      @resource = Resource.new(permitted_params[:resource])
      resource_img = params[:resource][:template_image]

      if @resource.image.blank?
        @resource.remote_image_url = resource_img
      end
      
      authorize! :create, @resource
      all_tags = (params[:resource][:tag_names] + "," + params["as_values_resource_tags"]).split(",").compact.uniq.reject{|t| t.blank? || t == Tag::PLACEHOLDER_TEXT}
      @resource.tag_names = all_tags.join(",")
      @resource.tags = all_tags.map{|t| Tag.find_or_create_by(name: t)}
      if @resource.save
        template_id = params[:resource][:resource_template_list]
        user_id = current_user.id
        if Resource.where(id: template_id.to_i).templates.present?
          ResourceTemplateUsage.create(user_id: user_id, resource_template_id: template_id, resource_id: @resource.id)
        end
        redirect_to admin_resource_path(resource), notice: "Resource created"
      else
        @resource_templates = Resource.templates
        @resource.template_image = params[:resource][:template_image]
        @user_agencies = current_admin_user.global_admin? ? Agency.all : Agency.where(id: (current_admin_user.roles.where(name: "agency_admin").pluck(:agency_id)))
        render :form, layout: 'active_admin'
      end
    end

  end

end

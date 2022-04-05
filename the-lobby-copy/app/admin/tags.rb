ActiveAdmin.register Tag do
  permit_params :name, :description, :q

  controller do
    def action_methods
      if current_admin_user.global_admin?
        super
      elsif current_admin_user.agency_admin?
        super - ['edit', 'destroy']
      else
        super
      end
    end
  end

  index do
    id_column
    column :name
    column :description
    column :created_at
    column :updated_at
    column 'Associated Resources' do |tag|
      tag.resources.each.map do |resource|
        " " + link_to(resource.title, admin_resource_path(resource))
      end.join(',').html_safe
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :username
      row :password
      row :created_at
      row :updated_at
      row 'Associated Resources' do |tag|
        tag.resources.map do |resource|
          " " + link_to(resource.title, admin_resource_path(resource))
        end.join(',').html_safe
      end
    end
  end

  collection_action :auto_suggest do
    if params[:q].present?
      tags = Tag.where("lower(name) LIKE ?", "%#{params[:q].downcase}%")
    else
      tags = Tag.all
    end
    render :json => tags.map{|t| {id: t.id, name: t.name}}
  end
end

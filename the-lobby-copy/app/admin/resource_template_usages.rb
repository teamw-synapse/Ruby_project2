ActiveAdmin.register ResourceTemplateUsage do
  menu if: proc{ current_admin_user.global_admin? }
  actions :index, :show
  
  index do
    id_column
		column :user
		column "Resource" do |resource_template_usage|
			link_to "#{resource_template_usage.resource_id}", admin_resource_path(resource_template_usage.resource_id)
		end
		column "Resource Template" do |resource_template_usage|
			link_to "#{resource_template_usage.resource_template_id}", admin_resource_path(resource_template_usage.resource_template_id)
    end
		actions
	end

	show do
    attributes_table do
      row :user
			row "Resource" do |resource_template_usage|
				link_to "#{resource_template_usage.resource_id}", admin_resource_path(resource_template_usage.resource_id)
			end
			row "Resource Template" do |resource_template_usage|
				link_to "#{resource_template_usage.resource_template_id}", admin_resource_path(resource_template_usage.resource_template_id)
			end
    end
  end
end
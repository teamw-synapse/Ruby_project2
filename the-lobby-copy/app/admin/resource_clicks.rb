ActiveAdmin.register ResourceClick do
  menu if: proc{ current_admin_user.global_admin? }
  actions :index
  remove_filter :created_at, :updated_at

  index do
    id_column
    column "Resource" do |rc|
      r=Resource.find(rc.resource_id)
      link_to r.title, admin_resource_path(r)
    end
    column "User" do |rc|
      User.find(rc.user_id)
    end
    column :count
    column :updated_at
  end
end

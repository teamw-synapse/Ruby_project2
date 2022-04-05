#ActiveAdmin.register_page "Dashboard" do
#
  #menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }
#
#  content title: proc{ I18n.t("active_admin.dashboard") } do
#    columns do
#      column do
#        panel "Resources" do
#          panel "Top Highlights" do
#            table_for Resource.where(highlight: true).order('highlight_position').limit(5) do
#              column("Url") {|resource| link_to(resource.url, resource.url)}
#              column("Title") {|resource| link_to(resource.title, admin_resource_path(resource))}
#              column("Description") { |resource| truncate(resource.description, omisiionb: "...", length: 100)}
#              column("Image") {|resource| image_tag(resource.image_url.to_s, width: 60, height: 40) if resource.image}
#            end
#          end
#          panel "Recent Global Resources" do
#            table_for Resource.where(global: true).order('id desc').limit(5) do
#              column("Url") {|resource| link_to(resource.url, resource.url)}
#              column("Title") {|resource| link_to(resource.title, admin_resource_path(resource))}
#              column("Description") { |resource| truncate(resource.description, omisiionb: "...", length: 100)}
#              column("Image") {|resource| image_tag(resource.image_url.to_s, width: 60, height: 40) if resource.image}
#            end
#          end
#        end
#      end
#
#      column do
#        panel "Recent Agencies" do
#          table_for Agency.order('id desc').limit(10) do
#            column do |agency|
#              li link_to(agency.name, admin_agency_path(agency))
#            end
#          end
#        end
#        panel "Recent Brandings" do
#          table_for Branding.order("id desc").limit(10) do
#            column do |branding|
#              li link_to(branding.name, admin_branding_path(branding))
#            end
#          end
#        end
#      end
#    end
#
#    columns do
#      column max_width: "50%" do
#        panel "Recent Tags" do
#          table_for Tag.order('id desc').limit(10) do
#            column("name") {|tag| link_to(tag.name, admin_tag_path(tag))}
#            column("description") {|tag| tag.description}
#          end
#        end
#      end
#    end
#  end
#end

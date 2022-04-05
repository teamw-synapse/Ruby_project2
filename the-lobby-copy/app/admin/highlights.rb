ActiveAdmin.register_page "Highlights" do
  menu parent: "Resources", priority: 1

  content do 
    render "highlight"
  end
end

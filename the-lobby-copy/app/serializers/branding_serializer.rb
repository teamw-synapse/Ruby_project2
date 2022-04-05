class BrandingSerializer < ActiveModel::Serializer
include Rails.application.routes.url_helpers
  attributes :id, :primary_color, :secondary_color, :font_url, :font_family, :logo_url

  def logo_url
    url_for(object.logo) if object.logo.attached?
  end
end

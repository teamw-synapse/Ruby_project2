class ResourceSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  
  attributes :id, :url, :title, :description, :tags, :image_url, :overview, :key_contact, :documentation, :show_info
  attribute :highlight_position, if: ->{ object.global? && object.highlight? }

  has_many :tags do
    object.tags.map do |tag|
      {id: tag.id, name: tag.name}
    end
  end

end

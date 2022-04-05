class TagSerializer < ActiveModel::Serializer
  attributes :id, :name, :description

  has_many :resources
end

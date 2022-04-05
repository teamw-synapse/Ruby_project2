class Role < ApplicationRecord
  belongs_to :user

  validates :name, presence: true

  GLOBAL_ADMIN_MEMBER_OF_STR = "CN=Admin,OU=mytbwa2,OU=Applications,OU=Groups,DC=globalad,DC=org"
end

class Resource < ApplicationRecord
  attr_accessor :tag_names, :image, :resource_template_list, :template_image


  has_and_belongs_to_many :tags
  accepts_nested_attributes_for :tags
  has_many :agencies_resources, dependent: :destroy
  accepts_nested_attributes_for :agencies_resources, allow_destroy: true

  has_many :agencies, through: :agencies_resources
  has_many :resource_clicks, dependent: :destroy
  has_many :resource_template_usages

  mount_uploader :image, ImageUploader


  before_validation :reject_blanks_in_agency_ids
  before_validation :add_protocol, if: lambda {|o| o.url.present? && !o.url.start_with?("http://" , "https://")}

  HTTP_URL_REGEXP = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix


  validates :title, :url, presence: true

  validates :url, format: { with: HTTP_URL_REGEXP, message: "This is not a valid URL. To override, select Local Resource" }, if: lambda {|o| o.url.present? && !o.is_local?}
  validates :documentation, format: { with: HTTP_URL_REGEXP, message: "Enter Url" }, if: lambda {|o| o.documentation.present?}
  validate :highlight_only_if_global_selected, if: -> (o){o.will_save_change_to_highlight? && o.highlight? && !o.global?}
  validate :image_present?

  validate :global_not_set_for_resource_template, if: lambda {|o| o.template? && o.global?}
  validate :username_and_password_not_set_for_resource_template, if: lambda {|o| o.template? && (o.username.present? || o.password.present?)}
  validate :agency_not_set_for_resource_template, if: lambda {|o| o.template? && o.agencies_resources.present?}

  before_save :update_highlight_position, if: :will_save_change_to_highlight?

  after_create :update_position
  scope :templates, -> {where(template: true)}

  def tag_names
    @tag_names ||= tags.pluck(:name).join(",")
  end

  def tag_names=(tag_names)
    @tag_names = tag_names
  end

  def self.set_global_resource_as_agency_resource_for_selected_agencies(agency_id)
      ids = Resource.where(global: true).select{|r| !r.agency_ids.include?(agency_id)}.map(&:id)
      Resource.where(id: ids)
  end
  
  private

  def reject_blanks_in_agency_ids
    return if self.agency_ids.blank?
    self.agency_ids = self.agency_ids.reject(&:blank?)
  end

  def update_position
    update_column(:position, id)
  end

  def update_highlight_position
    if highlight?
      self.highlight_position = (Resource.maximum(:highlight_position).to_i + 1)
    else
      self.highlight_position =  nil
    end
  end

  def highlight_only_if_global_selected
    if highlight? && !global?
      errors.add :highlight, "Highlight can be set for Global resources. Set the Global option for making the resource a highlight."
    end
  end


  def global_not_set_for_resource_template
    self.errors.add(:global, "Resource cannot be Global or Highlight if its a Template")
  end

  def username_and_password_not_set_for_resource_template
    self.errors.add(:username, "Resource cannot have Username and password if Template is selected")
  end
  def agency_not_set_for_resource_template
    self.errors.add(:template, "Resource cannot be a Template and have Agencies!")
  end

  def add_protocol
    self.url = "http://" + self.url
  end

  def image_present?
    self.errors.add(:image, "Please select an image") unless image.present?
  end
end

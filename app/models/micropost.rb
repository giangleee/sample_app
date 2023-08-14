class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display,
                       resize_to_limit: Settings.micropost.resize_to_limit
  end

  validates :content, presence: true,
            length: {maximum: Settings.digits.length_140}
  validates :image,
            content_type: {in: Settings.micropost.image_type,
                           message: :validate_type},
            size: {less_than: Settings.file.size_5.megabytes}

  scope :newest, -> {order created_at: :desc}

  delegate :name, to: :user, prefix: true

  def display_image
    image.variant resize_to_limit: Settings.micropost.resize_to_limit
  end
end

class Post < ApplicationRecord
    has_one_attached :image

    validate :image_presence
    validates :title, presence: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validate :image_type

    private

    def image_presence
        unless image.attached?
            errors.add(:image, "Vantar mynd!")
        end
    end

    def image_type
        if !image.content_type.in?(%('image/jpeg image/png'))
            errors.add(:image, 'Mynd verður að vera JPEG/JPG eða PNG')
        end
    end
end


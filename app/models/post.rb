class Post < ApplicationRecord
    has_one_attached :image

    validate :image_presence
    validates :title, presence: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

    private

    def image_presence
        unless image.attached?
            errors.add(:image, "Vantar mynd!")
        end
    end
end


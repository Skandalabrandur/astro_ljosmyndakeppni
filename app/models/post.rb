class Post < ApplicationRecord
    has_one_attached :image
    belongs_to :user

    validate :image_presence
    validates :title, presence: true

    private

    def image_presence
        unless image.attached?
            errors.add(:image, "Vantar mynd!")
        end
    end
end

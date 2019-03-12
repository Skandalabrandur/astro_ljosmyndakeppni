class Post < ApplicationRecord
    has_one_attached :image

    validates :title, presence: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validate :image_type

    private

    def image_type
	if image.attached?
        	if !image.content_type.in?(%('image/jpeg image/png'))
        	    errors.add(:image, 'Mynd verður að vera JPEG/JPG eða PNG')
        	end
	else
		errors.add(:image, "Vantar mynd!")
	end
    end
end


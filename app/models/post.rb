class Post < ApplicationRecord
    has_one_attached :image

    validates :title, presence: true, length: {minimum: 1, maximum: 20}
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validate :image_type
    validate :content_length

    def thumbnail
        return self.image.variant(resize: '200x200');
    end

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

    def content_length
        if content.length > 240
            errors.add(:content, "Texti við mynd: Vinsamlegast 240 stafir eða minna")
        end
    end

end


module UrlValidation
  extend ActiveSupport::Concern
  included do
    validate :url_is_an_image

    private

    def url_is_an_image
      return unless image_url

      accepted_suffixes = %w[jpg jpeg png]
      accepted = accepted_suffixes.include?(image_url.split('.').last)
      errors.add(:url_is_an_image, 'Please insert a valid image url') unless accepted
    end
  end
end

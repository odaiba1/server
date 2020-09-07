class CloudinaryUploader
  def initialize(image_url, photo)
    @image_url = image_url
    @photo = photo
  end

  def call
    if @image_url&.include?('res.cloudinary.com/')
      @image_url
    elsif @image_url || @photo
      source = @image_url || @photo
      cloudinary_data = Cloudinary::Uploader.upload(source)
      cloudinary_data['url']
    end
  end
end

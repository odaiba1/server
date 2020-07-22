class ImagesController < ApplicationController
  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)
    if @image.save
      render json: { url: Cloudinary::Utils.cloudinary_url(@image.photo.key) }.to_json,
             status: :created
    else
      render json: @image.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    render json: { msg: "Image #{params[:id]} successfully deleted" }.to_json
  end

  private

  def image_params
    params.require(:image).permit(:photo)
  end
end

require 'rails_helper'

RSpec.describe CloudinaryUploader, type: :service do
  let(:image_url) { nil }
  let(:photo)     { nil }
  subject { CloudinaryUploader.new(image_url, photo).call }

  context 'Cloudinary url' do
    let(:image_url) { 'https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg' }
    it 'returns same url' do
      expect(subject).to eq(image_url)
    end
  end

  context 'new image url' do
    # TODO: write stub request spec for uploading image
  end

  context 'attached image' do
    # TODO: write stub request spec for uploading image
  end

  context 'empty arguments' do
    it 'returns nil' do
      expect(subject).to eq(nil)
    end
  end
end

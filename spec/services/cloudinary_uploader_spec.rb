require 'rails_helper'

RSpec.describe CloudinaryUploader, type: :service do
  let(:image_url) { nil }
  let(:photo)     { nil }
  let(:mock_url)  { 'https://res.cloudinary.com/naokimi/image/upload/' }
  subject { CloudinaryUploader.new(image_url, photo).call }

  context 'Cloudinary url' do
    let(:image_url) { 'https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg' }
    it 'returns same url' do
      expect(subject).to eq(image_url)
    end
  end

  context 'image url from internet' do
    let(:image_url) { 'https://i.pinimg.com/originals/f2/81/58/f281580c10d323bfe4c1a938545d0a96.png' }
    it 'returns a cloudinary url' do
      allow(Cloudinary::Uploader).to receive(:upload).and_return(mock_url)
      expect(subject).to eq(mock_url)
    end
  end

  context 'attached image' do
    let(:photo) { '../support/files/img.jpg' }
    it 'returns a cloudinary url' do
      allow(Cloudinary::Uploader).to receive(:upload).and_return(mock_url)
      expect(subject).to eq(mock_url)
    end
  end

  context 'empty arguments' do
    it 'returns nil' do
      expect(subject).to eq(nil)
    end
  end
end

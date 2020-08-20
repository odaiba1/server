# == Schema Information
#
# Table name: worksheet_templates
#
#  id         :bigint           not null, primary key
#  image_url  :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_worksheet_templates_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe WorksheetTemplate, type: :model do
  let(:teacher) { create(:teacher) }
  subject do
    described_class.new(
      title: 'Test Worksheet Template',
      user: teacher,
      image_url: 'https://res.cloudinary.com/naokimi/image/upload/v1563422680/p7ojmgdtwshkrhxmjzh1.jpg'
    )
  end

  context 'valid' do
    it 'with valid attributes' do
      expect(subject).to be_valid
    end
  end

  context 'not valid' do
    it 'without a title' do
      subject.title = nil
      expect(subject).not_to be_valid
    end

    it 'without an image url' do
      subject.image_url = nil
      expect(subject).not_to be_valid
    end

    it 'with an image url in wrong format' do
      subject.image_url = 'this_isnt_a_url'
      expect(subject).not_to be_valid
    end

    it 'without a user' do
      subject.user = nil
      expect(subject).not_to be_valid
    end

    it 'with a student' do
      subject.user = create(:student)
      expect(subject).not_to be_valid
    end
  end
end

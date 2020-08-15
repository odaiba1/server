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
    described_class.new(title: 'Test Worksheet Template', user: teacher)
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

    it 'without a photo' do
      # to be implemented
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

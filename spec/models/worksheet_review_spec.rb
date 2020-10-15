# == Schema Information
#
# Table name: worksheet_reviews
#
#  id           :bigint           not null, primary key
#  content      :text
#  user_id      :bigint           not null
#  worksheet_id :bigint           not null
#
# Indexes
#
#  index_worksheet_reviews_on_user_id       (user_id)
#  index_worksheet_reviews_on_worksheet_id  (worksheet_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (worksheet_id => worksheets.id)
#
require 'rails_helper'

RSpec.describe WorksheetReview, type: :model do
  it 'has a valid factory' do
    expect(build(:worksheet_review)).to be_valid
  end

  let(:student) { create(:student) }
  let(:worksheet) { create(:worksheet)}
  subject do
    described_class.new(
      content: 'Test Worksheet Review',
      user: student,
      worksheet: worksheet
    )
  end

  context 'valid' do
    it 'with valid attributes' do
      expect(subject).to be_valid
    end
  end

  context 'not valid' do
    it 'without content' do
      subject.content = nil
      expect(subject).not_to be_valid
    end

    it 'without a user' do
      subject.user = nil
      expect(subject).not_to be_valid
    end

    it 'without a worksheet' do
      subject.worksheet = nil
      expect(subject).not_to be_valid
    end
  end

end

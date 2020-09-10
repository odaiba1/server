# == Schema Information
#
# Table name: student_work_groups
#
#  id            :bigint           not null, primary key
#  joined        :boolean
#  turn          :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#  work_group_id :bigint           not null
#
# Indexes
#
#  index_student_work_groups_on_user_id        (user_id)
#  index_student_work_groups_on_work_group_id  (work_group_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (work_group_id => work_groups.id)
#
require 'rails_helper'

RSpec.describe StudentWorkGroup, type: :model do
  it 'has a valid factory' do
    expect(build(:student_work_group)).to be_valid
  end

  let(:student)    { create(:student) }
  let(:work_group) { create(:work_group) }
  subject do
    described_class.new(work_group: work_group, user: student)
  end

  context 'valid' do
    it 'with valid attributes' do
      expect(subject).to be_valid
    end
  end

  context 'not valid' do
    it 'without a user' do
      subject.user = nil
      expect(subject).not_to be_valid
    end

    it 'without a work group' do
      subject.work_group = nil
      expect(subject).not_to be_valid
    end

    it 'with a teacher' do
      subject.user = create(:teacher)
      expect(subject).not_to be_valid
    end
  end
end

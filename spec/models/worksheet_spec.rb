# == Schema Information
#
# Table name: worksheets
#
#  id                    :bigint           not null, primary key
#  canvas                :string
#  image_url             :string
#  title                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  work_group_id         :bigint
#  worksheet_template_id :bigint
#
# Indexes
#
#  index_worksheets_on_work_group_id          (work_group_id)
#  index_worksheets_on_worksheet_template_id  (worksheet_template_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_group_id => work_groups.id)
#  fk_rails_...  (worksheet_template_id => worksheet_templates.id)
#
require 'rails_helper'

RSpec.describe Worksheet, type: :model do
  let(:worksheet_template) { create(:worksheet_template) }
  let(:work_group)         { create(:work_group) }
  subject do
    described_class.new(
      title: 'Test Worksheet',
      canvas: 'xyz',
      worksheet_template: worksheet_template,
      work_group: work_group
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

    it 'without a photo' do
      # to be implemented
    end

    it 'without a canvas' do
      subject.canvas = nil
      expect(subject).not_to be_valid
    end

    it 'without a template' do
      subject.worksheet_template = nil
      expect(subject).not_to be_valid
    end

    it 'with a work group' do
      subject.work_group = nil
      expect(subject).not_to be_valid
    end
  end
end

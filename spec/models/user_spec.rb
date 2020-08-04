# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  authentication_token   :string(30)
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("student")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  subject do
    described_class.new(
      name: 'Test User',
      email: 'test@mail.com',
      password: 'Password',
      role: (0..2).to_a.sample
    )
  end

  context 'valid' do
    it 'with valid attributes' do
      expect(subject).to be_valid
    end

    it 'with authentication token' do
      subject.authentication_token = 'abc'
      expect(subject).to be_valid
    end
  end

  context 'not valid' do
    it 'without a name' do
      subject.name = nil
      expect(subject).not_to be_valid
    end

    it 'without an email' do
      subject.email = nil
      expect(subject).not_to be_valid
    end

    it 'without a password' do
      subject.password = nil
      expect(subject).not_to be_valid
    end

    it 'without a role' do
      subject.role = nil
      expect(subject).not_to be_valid
    end
  end
end

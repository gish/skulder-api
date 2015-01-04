require 'rails_helper'
require 'spec_helper'

describe User, :type => :model do
  fixtures :users

  describe 'Required parameters' do
    it 'should not save without given name' do
      # given
      user = users(:missing_given_name)
      # then
      expect(user.save).to be false
    end

    it 'should not save without last name' do
      # given
      user = users(:missing_last_name)
      # then
      expect(user.save).to be false
    end

    it 'should not save without email' do
      # given
      user = users(:missing_email)
      # then
      expect(user.save).to be false
    end
  end

  describe 'Auto-generated values' do
    it 'should auto-generate uuid' do
      # given
      user = User.new(
        :given_name => 'John',
        :last_name => 'Foo',
        :email => 'john@foo.com'
      )
      # then
      expect(user.uuid).to_not be_nil
    end

    it 'should auto-generate secret' do
      # given
      user = User.new(
        :given_name => 'John',
        :last_name => 'Foo',
        :email => 'john@foo.com'
      )
      # then
      expect(user.secret).to_not be_nil
    end
  end
end

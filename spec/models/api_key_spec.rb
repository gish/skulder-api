require 'rails_helper'

RSpec.describe ApiKey, :type => :model do
  describe 'Required parameters' do
    it 'should not save without description' do
      # given
      apiKey = ApiKey.new
      # then
      expect(apiKey.save).to be false
    end
  end

  describe 'Creating' do
    it 'should generate access token' do
      # given
      apiKey = ApiKey.new(:description => 'App 1')
      # then
      expect(apiKey.access_token.blank?).to eql(false)
    end
  end
end

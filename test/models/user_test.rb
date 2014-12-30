require 'test_helper'

class UserTest < ActiveSupport::TestCase
    test 'should not save without given name' do
        user = users(:missing_given_name)
        assert_not user.save
    end

    test 'should not save without last name' do
        user = users(:missing_last_name)
        assert_not user.save
    end

    test 'should not save without email' do
        user = users(:missing_email)
        assert_not user.save
    end

    test 'should auto-generate uuid' do
        user = users(:complete)
        assert_not user.uuid.blank?
    end

    test 'should auto-generate secret' do
        user = users(:complete)
        assert_not user.secret.blank?
    end
end

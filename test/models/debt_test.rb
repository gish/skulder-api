require 'test_helper'

class DebtTest < ActiveSupport::TestCase
    test 'should auto-generate uuid' do
        debt = debts(:complete)
        assert_not debt.uuid.blank?
    end

    test 'should not save if amount missing' do
        debt = debts(:missing_amount)
        assert_not debt.save
    end

    test 'should not save if description missing' do
        debt = debts(:missing_description)
        assert_not debt.save
    end

    test 'should not save if loaner missing' do
        debt = debts(:missing_loaner)
        assert_not debt.save
    end

    test 'should not save if collector missing' do
        debt = debts(:missing_collector)
        assert_not debt.save
    end
end

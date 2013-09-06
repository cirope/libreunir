require 'test_helper'

class LoanTest < ActiveSupport::TestCase
  def setup
    @loan = Fabricate(:loan)
  end

  test 'create' do
    assert_difference 'Loan.count' do
      @loan = Loan.create(Fabricate.attributes_for(:loan))
    end 
  end

  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Loan.count' do
        assert @loan.update_attributes(capital: 100.0)
      end
    end

    assert_equal 100.0, @loan.reload.capital
  end

  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Loan.count', -1) { @loan.destroy }
    end
  end

  test 'should get last comments' do
    15.times { Fabricate(:comment, loan_id: @loan.id) }
    
    assert_equal 10, @loan.last_comments.size
  end

  test 'validates blank attributes' do
    @loan.loan_id = ''
    
    assert @loan.invalid?
    assert_equal 1, @loan.errors.size
    assert_equal [error_message_from_model(@loan, :loan_id, :blank)],
      @loan.errors[:loan_id]
  end

  test 'validates unique attributes' do
    new_loan = Fabricate(:loan)
    @loan.loan_id = new_loan.loan_id

    assert @loan.invalid?
    assert_equal 1, @loan.errors.size
    assert_equal [error_message_from_model(@loan, :loan_id, :taken)],
      @loan.errors[:loan_id]
  end

  test 'close to expire' do
    assert_no_difference 'Loan.close_to_expire.count' do
      Fabricate(:loan, canceled_at: Time.zone.now)
    end
  end

  test 'expired' do
    assert_difference 'Loan.expired.count' do
      Fabricate(:loan, expired_payments_count: 1)
    end
  end

  test 'not renewed' do
    assert_difference 'Loan.not_renewed.count' do
      Fabricate(:loan, canceled_at: 3.day.ago)
    end
  end

  test 'magick search' do
    5.times {
      Fabricate(:loan,
        client_id: Fabricate(:client, name: 'magick_name', lastname: 'magick_lastname').id
      )
    }
    Fabricate(:loan, loan_id: '1053810')

    loans = Loan.joins(:client).magick_search('magick')

    assert_equal 5, loans.count
    assert loans.all? { |l| l.client.to_s =~ /magick/ }

    loans = Loan.joins(:client).magick_search('magick_name')

    assert_equal 5, loans.count
    assert loans.all? { |l| l.client.to_s =~ /magick_name/ }

    loans = Loan.joins(:client).magick_search('1053810')

    assert_equal 1, loans.count
    assert loans.all? { |l| l.to_s =~ /1053810/ }

    loans = Loan.joins(:client).magick_search('nobody')

    assert loans.empty?
  end
end

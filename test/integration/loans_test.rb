require 'test_helper'

class LoansTest < ActionDispatch::IntegrationTest
  test 'should get loans with close to expire' do
    user = Fabricate(:user, password: '123456')
    3.times { Fabricate(:loan, user_id: user.id, next_payment_expire_at: Date.tomorrow) }

    login(user: user)

    click_link I18n.t('menu.loans')
    click_link I18n.t('view.loans.close_to_expire')

    assert page.has_css?('table[data-endless-container]')
    assert_equal 3, all('table[data-endless-container] tbody tr').size
  end

  test 'should get loans with expired' do
    user = Fabricate(:user, password: '123456')
    3.times do
      Fabricate(:loan, user_id: user.id, expired_payments_count: 1, next_payment_expire_at: 2.days.ago.to_date)
    end

    login(user: user)

    click_link I18n.t('menu.loans')
    click_link I18n.t('view.loans.expired')

    assert page.has_css?('table[data-endless-container]')
    assert_equal 3, all('table[data-endless-container] tbody tr').size
  end

  test 'should show and close loan info' do
    user = Fabricate(:user, password: '123456')
    3.times do
      Fabricate(:loan, user_id: user.id, expired_payments_count: 1, next_payment_expire_at: 2.days.ago.to_date)
    end
    loan = Fabricate(:loan, user_id: user.id, expired_payments_count: 1, next_payment_expire_at: 2.days.ago.to_date)

    login(user: user)
    
    click_link I18n.t('menu.loans')
    click_link I18n.t('view.loans.expired')

    assert page.has_no_selector?("tr[id=\"loan-info-#{loan.to_param}\"]")

    within "tr[data-object-id=\"#{loan.to_param}\"]" do
      click_link 'ℹ'
    end

    assert page.has_selector?("tr[id=\"loan-info-#{loan.to_param}\"]")

    within "tr[id=\"loan-info-#{loan.to_param}\"]" do
      find('.close').click
    end

    assert page.has_no_selector?("tr[id=\"loan-info-#{loan.to_param}\"]")
  end

  test 'should show error and create scheduled' do
    user = Fabricate(:user, password: '123456')
    3.times do
      Fabricate(:loan, user_id: user.id, expired_payments_count: 1, next_payment_expire_at: 2.days.ago.to_date)
    end
    loan = Fabricate(:loan, user_id: user.id, expired_payments_count: 1, next_payment_expire_at: 2.days.ago.to_date)
    schedule = Fabricate.build(:schedule)

    login(user: user)
    
    click_link I18n.t('menu.loans')
    click_link I18n.t('view.loans.expired')

    assert page.has_no_selector?("tr[data-schedulable-id=\"#{loan.to_param}\"]")

    within "tr[data-object-id=\"#{loan.to_param}\"]" do
      click_link ''
    end

    assert_no_difference 'Schedule.count' do
      within "tr[data-schedulable-id=\"#{loan.to_param}\"]" do
        assert page.has_no_css?('.alert.alert-error')

        find('.btn.btn-primary').click

        assert page.has_css?('div.error')
      end
    end

    assert_difference 'Schedule.count' do
      assert page.has_no_css?('.warning')

      within "tr[data-schedulable-id=\"#{loan.to_param}\"]" do
        within '.ui-datepicker-calendar' do
          click_link schedule.scheduled_at.day
        end

        fill_in 'schedule_description', with: schedule.description

        find('.btn.btn-primary').click
      end

      assert page.has_css?('.warning')
    end
  end
end

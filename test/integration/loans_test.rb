require 'test_helper'

class LoansTest < ActionDispatch::IntegrationTest
  setup do
    @user = Fabricate(:user, password: '123456', role: :normal)
  end

  test 'should get loans with close to expire' do
    3.times { Fabricate(:loan, user_id: @user.id, next_payment_expire_at: Date.tomorrow) }

    login(user: @user)

    within 'div.navbar-inner' do
      click_link I18n.t('menu.clients')
      click_link I18n.t('view.loans.close_to_expire')
    end

    assert page.has_css?('table[data-endless-container]')
    assert_equal 3, all('table[data-endless-container] tbody tr').size
  end

  test 'should get loans with expired' do
    3.times { fabricate_expired }
    login(user: @user)
  
    within 'div.navbar-inner' do
      click_link I18n.t('menu.clients')
      click_link I18n.t('view.loans.expired')
    end

    assert page.has_css?('table[data-endless-container]')
    assert_equal 3, all('table[data-endless-container] tbody tr').size
  end

  test 'should show and close loan info' do
    3.times { fabricate_expired }
    loan = fabricate_expired
    login(user: @user)
    
    within 'div.navbar-inner' do
      click_link I18n.t('menu.clients')
      click_link I18n.t('view.loans.expired')
    end

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
    loan = fabricate_expired
    schedule = Fabricate.build(:schedule)

    login(user: @user)
    
    within 'div.navbar-inner' do
      click_link I18n.t('menu.clients')
      click_link I18n.t('view.loans.expired')
    end

    assert page.has_no_selector?("div[data-schedulable-id=\"#{loan.to_param}\"]")

    within "tr[data-object-id=\"#{loan.to_param}\"]" do
      click_link ''
    end

    assert_no_difference 'Schedule.count' do
      within "div[data-schedulable-id=\"#{loan.to_param}\"]" do
        assert page.has_no_css?('.text.error')

        find('.btn-primary').click

        assert page.has_css?('.text.error')
      end
    end

    assert_difference 'Schedule.count' do
      assert page.has_no_css?('.warning')

      within "div[data-schedulable-id=\"#{loan.to_param}\"]" do
        within '.ui-datepicker-calendar' do
          click_link schedule.scheduled_at.day
        end

        fill_in 'schedule_description', with: schedule.description

        find('.btn.btn-primary').click
      end

      assert page.has_css?('.warning')
    end
  end

  private

  def fabricate_expired
    Fabricate(
      :loan, user_id: @user.id, expired_payments_count: 1,
      next_payment_expire_at: 2.days.ago.to_date, delayed_at: 2.days.ago.to_date
    )
  end
end

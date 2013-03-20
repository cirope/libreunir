# encoding: utf-8

require 'test_helper'

class DashboardTest < ActionDispatch::IntegrationTest
  test 'should get dashboard' do
    Fabricate(:client, product_id: 500000, name: "Nombre")
    Fabricate(:address, client_id: 500000, address: "calle 1153")
    Fabricate(:phone, client_id: 500000, phone: "1114123123")
    Fabricate(:call, client_id: 500000, call: "Notificacion")
    Fabricate(:order, order_id: 500000)
    Fabricate(:loan, order_id: 500000)
    Fabricate(:fee, expiration_date: Date.today+1, payment_date: Date.today+2, total_amount: 12000.0, loan_id: "500000", fee_number: 1)
    visit root_path

    login

    assert_equal dashboard_path, current_path

    assert_page_has_no_errors!
    assert page.has_css?('.alert')

    within '.close_to_expire' do
      name = all('td')[0].text
      assert_equal 'Nombre', name

      expire = all('td')[1].text
      assert_equal Date.today+1, expire

      all('a[href*=expiring_info]')[0].click

       within '.popover' do
         tables = all('.table')

         expiring_info = tables[0]
         notifications = tables[1]

         assert_equal 'Un dia tarde', expiring_info.all('td')[0].text
         assert_equal '12000.0', expiring_info.all('td')[1].text
         assert_equal '1114123123', expiring_info.all('td')[2].text
         assert_equal 'calle 1153', expiring_info.all('td')[3].text

         assert_equal 'Notificacion', notifications.all('td')[0].text
      end
    end
  end

  test 'should get client profile' do
    @user = Fabricate(:user, adviser_id: 'U123')
    Fabricate(:client, product_id: 500000, name: "Nombre")
    Fabricate(:address, client_id: 500000, address: "calle 1153")
    Fabricate(:phone, client_id: 500000, phone: "1114123123")
    Fabricate(:call, client_id: 500000, call: "Notificacion")
    Fabricate(:order, order_id: 500000)
    Fabricate(:loan, order_id: 500000)
    Fabricate(:fee, expiration_date: Date.today+1, payment_date: Date.today+2, total_amount: 12000.0, loan_id: "500000", fee_number: 1, paid_to: @user.adviser_id)
    Fabricate(:fee, expiration_date: Date.today+31.days, payment_date: nil, total_amount: 12000.0, loan_id: "500000", fee_number: 1)
    Fabricate(:fee, expiration_date: Date.today-31.days, payment_date: nil, total_amount: 12000.0, loan_id: "500000", fee_number: 1)
    visit root_path

    login

    assert_equal dashboard_path, current_path

    assert_page_has_no_errors!
    assert page.has_css?('.alert')

    click_link 'Nombre'

    within '.content' do
      personal_info = find('.personal-info')
      notifications = find('.notifications')
      fees = find('.fees')

      within '.personal-info' do
        name = personal_info.all('td')[0].text
        assert_equal 'Nombre', name

        phone = personal_info.all('td')[1].text
        assert_equal '1114123123', phone

        address = personal_info.all('td')[2].text
        assert_equal 'calle 1153', address
      end

      within '.notifications' do
        notification = notifications.all('td')[0].text
        assert_equal 'Notificacion', notification
      end

      within '.fees' do
        fees_data = fees.all('tr')
        assert_equal 4, fees_data.count

        first_fee = fees_data[1]
        second_fee = fees_data[2]
        third_fee = fees_data[3]

        assert page.has_css?('.error')
        assert page.has_css?('.muted')
        assert page.has_css?('.success')

        assert '12000', first_fee.all('td')[0].text
        assert '12000', second_fee.all('td')[0].text
        assert '12000', third_fee.all('td')[0].text
      end
    end
  end

  test 'should get expired' do
    101.times { Fabricate(:fee, expiration_date: 3.days.ago) }

    visit root_path
    login

    assert_equal dashboard_path, current_path

    assert_page_has_no_errors!
    assert page.has_css?('.alert')

    fill_in 'date_range_start', with: 3.month.ago.at_beginning_of_month.strftime("%d/%m/%Y")
    fill_in 'date_range_end', with: Date.today.at_end_of_month.strftime("%d/%m/%Y")
    find('input.btn.btn-primary').click

    click_link 'Vencidos'
    row_count = all('tbody tr').size
    assert row_count < 101

    until row_count == 101
      page.execute_script 'window.scrollBy(0,10000)'

      assert page.has_css?("tbody tr:nth-child(#{row_count + 1})")

      row_count = all('tbody tr').size
    end
  end

  test 'should get close to expire' do
    101.times { Fabricate(:fee, expiration_date: rand(1.month).ago) }

    visit root_path
    login

    assert_equal dashboard_path, current_path

    assert_page_has_no_errors!
    assert page.has_css?('.alert')

    fill_in 'date_range_start', with: 1.month.ago.at_beginning_of_month.strftime("%d/%m/%Y")
    find('input.btn.btn-primary').click

    click_link 'Por vencer'
    row_count = all('tbody tr').size
    assert row_count < 101

    until row_count == 101
      page.execute_script 'window.scrollBy(0,10000)'

      assert page.has_css?("tbody tr:nth-child(#{row_count + 1})")
      row_count = all('tbody tr').size
    end
  end

  test 'should see the button _print_' do
    login

    click_link 'Vencidos'

    assert page.has_css?('.print')

    print = find('.print').text

    assert 'Imprimir', print
  end

  test 'should get dependent clients' do
    user = Fabricate(:user, password: '123456', role: :regular, adviser_id: 'ADV1')
    user_2 = Fabricate(:user, password: '123456', role: :regular, adviser_id: 'ADV2')
    Fabricate(:relation, relation: 'dependent', user_id: user.id, relative_id: user_2.id)

    Fabricate(:client, product_id: 500000, name: "Nombre")
    Fabricate(:address, client_id: 500000, address: "calle 1153")
    Fabricate(:phone, client_id: 500000, phone: "1114123123")
    Fabricate(:call, client_id: 500000, call: "Notificacion")
    Fabricate(:order, order_id: 500000, adviser_id: user_2.adviser_id, user_id: user_2.adviser_id)
    Fabricate(:loan, order_id: 500000)
    Fabricate(:fee, expiration_date: Date.today+1, payment_date: nil, total_amount: 12000.0, loan_id: 500000, fee_number: 1)
    visit root_path

    login_with(user)

    assert_equal dashboard_path, current_path

    assert_page_has_no_errors!
    assert page.has_css?('.alert')

    within '.users_auto_user_name' do
      fill_in find('input.autocomplete_field')[:id], with: user_2.name
    end

    find('.ui-autocomplete li.ui-menu-item a').click

    find('input.btn.btn-primary').click

    within '#close_to_expire' do
      assert_equal 2, all('tr').count
    end
  end
end

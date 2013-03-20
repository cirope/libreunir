# encoding: utf-8

require 'test_helper'

class DashboardTest < ActionDispatch::IntegrationTest
  test 'should get dashboard' do
    Fabricate(:client, product_id: "PR1", name: "Nombre" )
    Fabricate(:address, client_id: "PR1", address: "calle 1153")
    Fabricate(:phone, client_id: "PR1", phone: "1114123123")
    Fabricate(:call, client_id: "PR1", call: "Notificacion")
    Fabricate(:fee, expiration_date: Date.today+1, payment_date: Date.today+2, total_amount: 12000.0, client_id: "PR1", fee_number: 1)
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

         assert_equal '1 dia tarde', expiring_info.all('td')[0].text
         assert_equal '12000.0', expiring_info.all('td')[1].text
         assert_equal '1114123123', expiring_info.all('td')[2].text
         assert_equal 'calle 1153', expiring_info.all('td')[3].text

         assert_equal 'Notificacion', notifications.all('td')[0].text
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
end

# encoding: utf-8

require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  test 'should create a new user with relations' do
    login

    visit new_user_path

    user_attributes = Fabricate.attributes_for(:user)

    fill_in 'user_name', with: user_attributes['name']
    fill_in 'user_lastname', with: user_attributes['lastname']
    fill_in 'user_email', with: user_attributes['email']
    fill_in 'user_password', with: user_attributes['password']
    fill_in 'user_password_confirmation',
      with: user_attributes['password_confirmation']

    find('#user_role_admin').click

    relative = Fabricate(:user)

    within '#relations fieldset' do
      fill_in find('input[name$="[auto_user_name]"]')[:id], with: relative.name
    end

    find('.ui-autocomplete li.ui-menu-item a').click

    within '#relations fieldset' do
      select I18n.t("view.relation.types.#{Relation::TYPE.first}"),
        from: find('select[name$="[relation]"]')[:id]
    end

    assert page.has_no_css?('#relations fieldset:nth-child(2)')

    click_link I18n.t('view.users.new_relation')

    assert page.has_css?('#relations fieldset:nth-child(2)')

    # Must be removed before the next search, forcing the new "creation"
    page.execute_script("$('.ui-autocomplete').html('')")

    relative = Fabricate(:user)

    within '#relations fieldset:nth-child(2)' do
      fill_in find('input[name$="[auto_user_name]"]')[:id], with: relative.name
    end

    find('.ui-autocomplete li.ui-menu-item a').click

    within '#relations fieldset:nth-child(2)' do
      select I18n.t("view.relation.types.#{Relation::TYPE.first}"),
        from: find('select[name$="[relation]"]')[:id]
    end

    assert_difference 'User.count' do
      assert_difference 'Relation.count', 2 do
        find('.btn.btn-primary').click
      end
    end
  end

  test 'should delete all relation inputs' do
    login

    visit new_user_path

    assert page.has_css?('#relations fieldset')

    within '#relations fieldset' do
      click_link '✘' # Destroy link
    end

    assert page.has_no_css?('#relations fieldset')
  end

  test 'should hide and mark for destruction a relation' do
    login

    user = Fabricate(:user) { relations { [Fabricate(:relation)] } }

    visit edit_user_path(user)

    assert page.has_css?('#relations fieldset')

    within '#relations fieldset:nth-child(1)' do
      click_link '✘' # Destroy link
    end

    assert_no_difference 'User.count' do
      assert_difference 'Relation.count', -1 do
        find('.btn.btn-primary').click
      end
    end
  end

  test 'scroll in endless index' do
    100.times { Fabricate(:user) }

    login

    visit users_path

    row_count = all('tbody tr').size

    assert row_count < 101

    until row_count == 101
      page.execute_script 'window.scrollBy(0,10000)'

      assert page.has_css?("tbody tr:nth-child(#{row_count + 1})")

      row_count = all('tbody tr').size
    end
  end
end

require 'test_helper'

class TagsTest < ActionDispatch::IntegrationTest
  setup do
    @user = Fabricate(:user, password: '123456', role: :normal)
  end

  test 'should create a tag' do
    tag = Fabricate.attributes_for(:tag, user_id: nil)

    login(user: @user)

    visit expired_loans_path

    assert page.has_no_css?('form#new_tag')

    within 'li.tag_new' do
      click_link I18n.t('view.tags.new')
    end

    assert page.has_css?('form#new_tag')

    assert_difference 'Tag.count' do
      within 'div[data-tags-new]' do
        fill_in 'tag_name', with: tag[:name]

        find('.btn.btn-primary').click
      end
      
      sleep 1
    end
  end

=begin
  test 'should create a tagging' do
    tag = Fabricate(:tag, category: 'important', user_id: @user.id)
    loan = Fabricate(:loan, user_id: @user.id)

    login(user: @user)

    visit close_to_expire_loans_path

    within "tr[data-object-id=\"#{loan.id}\"]" do
      find("input[type='checkbox']").click
    end

    click_link 'navtags'

    assert_difference 'Tagging.count' do
      find("[data-tag-id=\"#{tag.id}\"]").click
    
      assert page.has_css?('.badge.badge-important')
    end
  end
=end
end

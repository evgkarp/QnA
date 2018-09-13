require_relative 'acceptance_helper'

feature 'Search', %q{
  In order to find information
  As user
  I want to search info in questions, answers, comments and users
} do

  given!(:user) { create(:user, email: "search@mail.ru") }
  given!(:question) { create(:question, user: user) }

  context 'User' do
    scenario 'sees search field with attributes' do
      visit root_path
      %w(Everywhere Question Answer Comment User).each do |category|
        expect(page).to have_content category
      end
    end

    scenario 'searches and sees result page', js: true, sphinx: true do
      ThinkingSphinx::Test.run do
        # save_and_open_page
        ThinkingSphinx::Test.index
        visit root_path
        fill_in 'query', with: 'Nothing'
        click_on 'Search'

        expect(page).to have_content "No results"
      end
    end

    # scenario 'searches in category Question', js: true do
    #   ThinkingSphinx::Test.run do
    #     ThinkingSphinx::Test.index
    #     visit root_path
    #     fill_in 'query', with: 'category'
    #     select 'Question', from: 'category'
    #     click_on 'Search'

    #     within '.results' do
    #       expect(page).to have_content question.title
    #       expect(page).to_not have_content answer.body
    #       expect(page).to_not have_content user.email
    #     end
    #   end
    # end
  end
end

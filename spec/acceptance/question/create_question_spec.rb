require_relative '../acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do
  given(:user) { create(:user) }

  scenario 'Authenticated user creates a question' do
    sign_in(user)

    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    click_on 'Create'

    expect(page).to have_content 'Question was successfully created'
  end

  scenario 'Non-authenticated creates a question' do
    visit questions_path

    expect(page).to_not have_link 'Ask question'
  end

  scenario 'Authenticated user creates an invalid question' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    click_on 'Create'

    expect(page).to have_content "Title can't be blank"
  end

  context "mulitple sessions", js: true do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
        click_on 'Create'

        expect(page).to have_content 'Question was successfully created'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end
end

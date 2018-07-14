require_relative '../acceptance_helper'

feature 'Create answer', %q{
  In order to help to somebody
  As an authenticated user
  I want to be able to answer the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user creates an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your Answer', with: 'TestContent'
    click_on 'Post Your Answer'

    within '.answers' do
      expect(page).to have_content 'TestContent'
    end
  end

  scenario 'Non-authenticated user creates an answer', js: true do
    visit question_path(question)
    fill_in 'Your Answer', with: 'TestContent'
    click_on 'Post Your Answer'

    expect(page).to_not have_content 'TestContent'
  end

  scenario 'Authenticated user creates an invalid answer', js: true do
    sign_in(user)

    visit question_path(question)
    click_on 'Post Your Answer'

    expect(page).to have_content "Body can't be blank"
  end

  context "mulitple sessions", js: true do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your Answer', with: 'TestContent'
        click_on 'Post Your Answer'

        within '.answers' do
          expect(page).to have_content 'TestContent'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'TestContent'
        end
      end
    end
  end
end

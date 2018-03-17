require_relative '../acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an author of question
  I want to be able to edit my question
} do
  given!(:user) { create(:user) }
  given!(:second_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user edits an question', js: true do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_content 'Edit question'
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his question', js: true do
      within '.question' do
        click_on 'Edit question'
        fill_in 'Title', with: 'edited question title'
        fill_in 'Body', with: 'edited question body'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question title'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario "sees link 'Edit question'", js: true do
      within '.question' do
        expect(page).to have_button 'Edit question'
      end
    end
  end

  scenario "Authenticated user edits other user's question", js: true do
    sign_in(second_user)
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_content 'Edit question'
    end
  end
end

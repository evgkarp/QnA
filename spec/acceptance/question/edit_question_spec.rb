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
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit questions_path
    end

    scenario 'edits his question', js: true do
      click_on 'Edit'
      fill_in 'Title', with: 'edited question title'
      fill_in 'Body', with: 'edited question body'
      click_on 'Save'

      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited question title'
      expect(page).to_not have_selector 'textarea'
    end

    scenario "sees link 'Edit'", js: true do
      expect(page).to have_link 'Edit'
    end
  end

  scenario "Authenticated user edits other user's question", js: true do
    sign_in(second_user)
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end
end

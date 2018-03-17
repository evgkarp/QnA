require_relative '../acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of answer
  I want to be able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:second_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user)}

  scenario 'Unauthenticated user edits an answer', js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Edit answer'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his answer', js: true do
      click_on 'Edit answer'
      within '.answers' do
        fill_in 'Your Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario "sees link 'Edit answer'", js: true do
      within '.answers' do
        expect(page).to have_button 'Edit answer'
      end
    end
  end

  scenario "edits other user's answer", js: true do
    sign_in(second_user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_content 'Edit answer'
    end
  end
end

require_relative 'acceptance_helper'

feature 'Vote', %q{
  In order to stimulate users to create helpful questions and answers
  As an authenticated user
  I want to be able to vote for questions and answers
  } do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) {create(:answer, question: question, user: author)}

  scenario 'all users can see rating of question', js: true do
    sign_in(author)
    visit question_path(question)

    within '.question' do
      expect(page).to have_css '.rating'
    end
  end

  describe 'Non-author' do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'can not vote for his question', js: true do
      within '.question' do
        expect(page).to_not have_link('+')
        expect(page).to_not have_link('-')
      end
    end

    scenario 'can not vote for his answer', js: true do
      within '.answers' do
        expect(page).to_not have_link('+')
        expect(page).to_not have_link('-')
      end
    end
  end

  describe 'Non-author' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'votes for question', js: true do
      within '.question' do
        click_on '+'
        expect(page).to have_content 1
      end
    end

    scenario 'votes against question', js: true do
      within '.question' do
        click_on '-'
        expect(page).to have_content -1
      end
    end

    scenario 'resets his vote for question', js: true do
      within '.question' do
        click_on '+'
        click_on 'Reset Vote'
        expect(page).to have_content 0
      end
    end

    scenario 'votes for answer', js: true do
      within "#answer-id-#{answer.id}" do
        click_on '+'
        expect(page).to have_content 1
      end
    end

    scenario 'votes against answer', js: true do
      within "#answer-id-#{answer.id}" do
        click_on '-'
        expect(page).to have_content -1
      end
    end

    scenario 'resets his vote for answer', js: true do
      within "#answer-id-#{answer.id}" do
        click_on '+'
        click_on 'Reset Vote'
        expect(page).to have_content 0
      end
    end

    scenario 'can not votes for answer twice', js: true do
      within "#answer-id-#{answer.id}" do
        click_on '+'
        expect(page).to have_content 1
        expect(page).to_not have_link('+')
        expect(page).to_not have_link('-')
      end
    end
  end
end

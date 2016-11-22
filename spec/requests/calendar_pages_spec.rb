require 'spec_helper'
require 'user_helper'

describe "CalendarPages" do
	include_context "login user"

  describe 'show' do
  	let!(:memory_in_calendar) { FactoryGirl.create(:memory, user: user, occured_at: Date.today) }
		let!(:memory_outside_of_calendar) { FactoryGirl.create(:memory, user: user, occured_at: 2.month.ago) }

    before {visit calendar_path}

    describe 'title and page_title' do
			it { should have_title(full_title(I18n.t('views.calendar'))) }
			specify { expect(find('#page_title')).to have_content(I18n.t('views.calendar')) }
		end

		describe 'calendar' do
		  it { should have_css("div.simple-calendar") }

		  describe 'events' do
		  	it 'contains today memory' do
		  		expect(page).to have_link(memory_in_calendar.title, href: memory_path(memory_in_calendar))
		  	end

		  	it 'not contains olds memory' do
		  		expect(page).to_not have_link(memory_outside_of_calendar.title, href: memory_path(memory_outside_of_calendar))
		  	end
		  end
		end
  end
end

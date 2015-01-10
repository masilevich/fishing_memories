require 'spec_helper'

describe "Static pages" do

	subject { page }

	describe "Home page" do
		before { visit root_path }

		it { should have_title(full_title) }

		describe "logo" do
			specify do
			  within 'div#site_title' do
			    expect(page).to have_link(full_title, href: root_path)
			  end
			end
		end

		describe "header links" do
			it { should have_link(I18n.translate('fishing_memories.devise.sign_in.title'), href: new_user_session_path) }
			it { should have_link(I18n.translate('fishing_memories.devise.sign_up.title'), href: new_user_registration_path) }
		end

		describe "content" do
			it { should have_selector('h1',    text: "Добро пожаловать в Рыболовные записки") }
		end
		
	end

end
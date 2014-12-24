require 'spec_helper'

describe "Static pages" do

	subject { page }

	describe "Home page" do
		before { visit root_path }
		describe "header links" do
			it { should have_link("Рыболовные воспоминания", href: root_path) }
			it { should have_link("Войти", href: new_user_session_path) }
			it { should have_link("Регистрация", href: new_user_registration_path) }
		end

		describe "content" do
			it { should have_selector('h1',    text: "Добро пожаловать в Рыболовные записки") }
		end
		
	end

end
require 'spec_helper'

describe "DevisePages" do
  include Warden::Test::Helpers
  Warden.test_mode!
  after(:each) { Warden.test_reset! }

  subject { page }
  let(:signin_label) { I18n.translate('fishing_memories.devise.sign_in.title') }
  let(:signout_label) { I18n.translate('fishing_memories.sign_out') }
  let(:signup_label) { I18n.translate('fishing_memories.devise.sign_up.title') }

  describe "signin" do
    before do
      logout(:user)
      visit new_user_session_path
    end 

    let(:submit) { signin_label }

    describe "page" do
      it { should have_selector('h2',    text: signin_label) }
      it { should have_title(full_title(signin_label)) }
      it { should have_link(signup_label, href: new_user_registration_path) }
    end

    describe "with invalid information" do

      describe "after submission" do
        before { click_button submit }
        it { should have_selector('h2',    text: signin_label) }
        it { should have_title(full_title(signin_label)) }
        it { should_not have_link(signout_label, href: destroy_user_session_path) }
        it { should have_selector('div.flash.flash_alert', text: "Неверный логин или пароль.") }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:confirmed_user) }

      describe "login as email" do
        before do
          fill_in "user_login",     with: user.email
          fill_in "user_password",     with: user.password
          click_button submit
        end
        it { should have_selector('div.flash.flash_notice', text: "Вход в систему выполнен.") }
        it { should_not have_link(signup_label, href: new_user_registration_path) }
        it { should_not have_link(signin_label, href: new_user_session_path) }
        it { should have_link(user.email, href: edit_user_registration_path(user)) }
        it { should have_link(signout_label, href: destroy_user_session_url) }

        describe "followed by signout" do
          before { click_link signout_label }
          it { should have_link(signin_label) }
        end
      end

      describe "login as username" do
        before do
          fill_in "user_login",     with: user.username
          fill_in "user_password",     with: user.password
          click_button submit
        end
        it { should have_content("Вход в систему выполнен.") }
      end

=begin
      describe "redirect" do

        describe "default" do
          let(:user) { FactoryGirl.create(:confirmed_user,sign_in_count: 2, last_sign_in_at: Time.now) }
          before do
            fill_in "user_login",     with: user.email
            fill_in "user_password",     with: user.password
            click_button submit
          end
          it { should have_title(full_title('Случайный рецепт')) }
        end
      end
=end
    end
  end


  describe "signup" do

    before { visit new_user_registration_path }

    let(:submit) { signup_label }

    describe "page" do

      it { should have_selector('h2',    text: signup_label) }
      it { should have_title(full_title(signup_label)) }
    end

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title(full_title(signup_label)) }
        it { should have_content('ошибк') }
      end
    end

    describe "with valid information" do
      let(:email) { "user@example.com" }
      before do
        fill_in "user_username",   with: "example_user"
        fill_in "user_email",        with: email
        fill_in "user_password",     with: "foobar"
        fill_in "user_password_confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }

        it { should have_selector('div.flash.flash_notice', 
          text: I18n.translate('devise.confirmations.send_instructions')) }

        it "should send notification" do
          expect(ActionMailer::Base.deliveries.last.to).to eq [email]
          expect(ActionMailer::Base.deliveries.last.subject).to eq I18n.translate('devise.mailer.confirmation_instructions.subject')
        end
      end
    end
  end
end

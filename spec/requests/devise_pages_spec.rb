require 'spec_helper'

describe "DevisePages" do
  include Warden::Test::Helpers
  Warden.test_mode!
  after(:each) { Warden.test_reset! }

  subject { page }
  let(:signin_label) { I18n.translate('fishing_memories.devise.sign_in.title') }
  let(:signout_label) { I18n.translate('fishing_memories.sign_out') }
  let(:signup_label) { I18n.translate('fishing_memories.devise.sign_up.title') }

  shared_examples "memories index page" do
    it { should have_title(full_title(Memory.model_name.human count: PLURAL_MANY_COUNT)) }
  end

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
        it { should have_error_message("Неверный логин или пароль.") }
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
        it { should have_success_message("Вход в систему выполнен.") }
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

      describe "redirect" do

        describe "default" do
          let(:user) { FactoryGirl.create(:confirmed_user) }
          before do
            fill_in "user_login",     with: user.email
            fill_in "user_password",     with: user.password
            click_button submit
          end
          it_behaves_like "memories index page"
        end
      end
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

        it { should have_success_message(I18n.translate('devise.confirmations.send_instructions')) }

        it "should send notification" do
          expect(ActionMailer::Base.deliveries.last.to).to eq [email]
          expect(ActionMailer::Base.deliveries.last.subject).to eq I18n.translate('devise.mailer.confirmation_instructions.subject')
        end
      end
    end
  end

  describe "authenticated root" do
    let(:user) { FactoryGirl.create(:confirmed_user) }
    before do
      login_as(user, :scope => :user)
      visit root_path
    end
    it_behaves_like "memories index page"

    describe "logo" do
      specify do
        within 'div#site_title' do
          expect(page).to have_link((Memory.model_name.human count: PLURAL_MANY_COUNT), href: root_path)
        end
      end
    end
  end

  describe "edit registration" do
    let(:user) { FactoryGirl.create(:confirmed_user) }
    let(:submit) {I18n.translate('fishing_memories.devise.edit_registration.submit')}
    before do
      login_as(user, :scope => :user)
      visit edit_user_registration_path(user)
    end 

    describe "page" do
      it { should have_content(I18n.translate('fishing_memories.devise.edit_registration.title')) }
      it { should have_title(I18n.translate('fishing_memories.devise.edit_registration.title')) }
    end

    describe "with valid information" do
      describe "change username and password" do
        let(:new_user_name)  { "new_user_name" }
        let(:new_password) { "newpassword" }
        before do
          fill_in "user_username",        with: new_user_name
          fill_in "user_password",         with: new_password
          fill_in "user_password_confirmation", with: new_password
          fill_in "user_current_password", with: user.password
          click_button submit
        end
        it { should have_success_message(I18n.translate('devise.registrations.updated')) }
        specify { expect(user.reload.username).to  eq new_user_name }
      end

      describe "change email" do
        let(:new_email) { "new@example.com" }
        before do
          fill_in "user_email",            with: new_email
          fill_in "user_current_password", with: user.password
          click_button submit
        end

        it { should have_success_message( I18n.translate('devise.registrations.update_needs_confirmation')) }

        describe "should be unconfirmed" do
          before {visit edit_user_registration_path(user)}
          it { should have_content(I18n.translate('fishing_memories.devise.edit_registration.unconfirmed_email') + ": #{new_email}") }
        end

        it "should send notification" do
          expect(ActionMailer::Base.deliveries.last.to).to eq [new_email]
          expect(ActionMailer::Base.deliveries.last.subject).to eq I18n.translate('devise.mailer.confirmation_instructions.subject')
        end
      end
    end
  end

  describe "resend confirmation instructions" do
    before (:each) {ActionMailer::Base.deliveries.clear}
    let(:submit) {click_button I18n.translate('fishing_memories.devise.resend_confirmation_instructions.submit')}

    describe "for unconfirmed user" do

      let(:user) { FactoryGirl.create(:user) }
      before do
        visit new_user_confirmation_path
        fill_in "user_email", with: user.email
        click_button submit
      end

      it "should send notification" do
        expect(ActionMailer::Base.deliveries.last.to).to eq [user.email]
        expect(ActionMailer::Base.deliveries.last.subject).to eq I18n.translate('devise.mailer.confirmation_instructions.subject')
      end
    end

    describe "for confirmed user" do

      let(:user) { FactoryGirl.create(:confirmed_user) }
      before do
        visit new_user_confirmation_path
        fill_in "user_email", with: user.email
        click_button submit
      end

      it "should not send notification" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    describe "for random email" do
      before do
        visit new_user_confirmation_path
        fill_in "user_email", with: "random@example.com"
        click_button submit
      end

      it "should not send notification" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe "reset password instructions" do
    let(:submit) {I18n.translate('fishing_memories.devise.reset_password.submit')}
    before (:each) {ActionMailer::Base.deliveries.clear}
    describe "for unconfirmed user" do

      let(:user) { FactoryGirl.create(:user) }
      before do
        visit new_user_password_path
        fill_in "user_email", with: user.email
        click_button submit
      end

      it "should send notification" do
        expect(ActionMailer::Base.deliveries.last.to).to eq [user.email]
        expect(ActionMailer::Base.deliveries.last.subject).to eq I18n.translate('devise.mailer.reset_password_instructions.subject')
      end
    end

    describe "for confirmed user" do

      let(:user) { FactoryGirl.create(:confirmed_user) }
      before do
        visit new_user_password_path
        fill_in "user_email", with: user.email
        click_button submit
      end

      it "should send notification" do
        expect(ActionMailer::Base.deliveries.last.to).to eq [user.email]
        expect(ActionMailer::Base.deliveries.last.subject).to eq I18n.translate('devise.mailer.reset_password_instructions.subject')
      end
    end

    describe "for random email" do
      before do
        visit new_user_password_path
        fill_in "user_email", with: "random@example.com"
        click_button submit
      end

      it "should not send notification" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end

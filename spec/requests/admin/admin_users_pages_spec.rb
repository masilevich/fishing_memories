require 'spec_helper'
require 'user_helper'
require "requests/shared_examples/filter"

describe "Admin::UsersPages" do

	let(:resource_class) { User }
	let!(:namespace) {:admin}

	include_context "login admin"

	describe "index" do

		let!(:users) { FactoryGirl.create_list(:user, 3) }
		before {visit admin_users_path}

		describe "table" do

			it "should have header" do
				expect(page).to have_selector('th', text: User.human_attribute_name("email"))
				expect(page).to have_selector('th', text: User.human_attribute_name("username"))
				expect(page).to have_selector('th', text: User.human_attribute_name("role"))
				expect(page).to have_selector('th', text: Memory.human_attribute_name("count"))
			end

			it "should have content and action links" do
				users.each do |user|
					expect(page).to have_selector('td', text: user.email)
					expect(page).to have_selector('td', text: user.username)
					expect(page).to have_selector('td', text: user.role)
					expect(page).to have_selector('td', text: user.memories.count)
				end
			end

		end

		describe "filter" do
			let!(:first) { users.first }
			let!(:second) { users.second }
			let!(:third) { users.third }
			let!(:other) { FactoryGirl.create(:user) }

			it_should_behave_like "filter", email: :cont,  username: :cont

		end
	end

=begin
	describe "create" do
		let(:submit) {I18n.t('fishing_memories.new_model', model: Memory.model_name.human)}
		let!(:ponds) { FactoryGirl.create_list(:pond, 2, user: user) }
		let!(:places) { FactoryGirl.create_list(:place, 2, user: user, pond: ponds.first) }
		let!(:place_without_pond) { FactoryGirl.create(:place, user: user) }
		let!(:tackles) { FactoryGirl.create_list(:tackle, 2, user: user) }
		let!(:tackle_sets) { FactoryGirl.create_list(:tackle_set, 2, user: user) }

		describe "select" do

			let(:other_user) { FactoryGirl.create(:confirmed_user) }
			let!(:other_user_tackles) { FactoryGirl.create(:tackle, user: other_user) }
			let!(:other_user_tackle_sets) { FactoryGirl.create(:tackle_set, user: other_user) }
			let!(:other_user_ponds) { FactoryGirl.create(:pond, user: other_user) }
			before do
				visit new_memory_path
				tackle_sets.first.tackles << tackles
				tackle_sets.first.save
			end

			context "tackles" do
				it { should have_select('memory[tackle_ids][]', :options => tackles.map { |e| e.name}.sort) }
			end

			context "tackle sets" do
				it { should have_select('memory[tackle_set_ids][]', :options => tackle_sets.map { |e| e.name}.sort) }
			end

			context "ponds" do
				it { should have_select('memory[pond_ids][]', :options => ponds.map { |e| e.name}.sort) }
			end

			context "places" do
				it { should have_select('memory[place_ids][]', :with_options => user.places.map { |e| e.name}.sort) }
			end

		end

		describe "with valid information" do

			before do
				visit new_memory_path
				@occured_at = DateTime.now.to_date
				fill_in "memory_occured_at", with: @occured_at
			end

			it "should create a memory" do
				expect { click_button submit }.to change(Memory, :count).by(1)
			end

			describe "success messages" do
				before { click_button submit }
				it { should have_success_message(I18n.t('fishing_memories.model_created', model: Memory.model_name.human)) }
			end

			context 'memory fields' do
				before do
					@weather_string = "5 градусов тепла, южный ветер"
					@pond_state = "Температуры воды +5"
					@description = "Рыбалка 5-го ноября"
					@conclusion = "Клев как на черных камнях"
					fill_in "memory_description", with: @description
					fill_in "memory_conclusion", with: @conclusion
					select tackles.first.name, :from => "memory[tackle_ids][]"
					select tackle_sets.first.name, :from => "memory[tackle_set_ids][]"
					select ponds.first.name, :from => "memory[pond_ids][]"
					select places.first.name, :from => "memory[place_ids][]"
					fill_in "memory_weather", with: @weather_string
					fill_in "memory_pond_state", with: @pond_state
					click_button submit
					@memory = Memory.order("created_at").last
				end
				it "should have entered values" do
					expect(@memory.occured_at).to eq @occured_at
					expect(@memory.description).to eq @description
					expect(@memory.conclusion).to eq @conclusion
					expect(@memory.weather).to eq @weather_string
					expect(@memory.pond_state).to eq @pond_state
					expect(@memory.ponds.first).to eq ponds.first
					expect(@memory.places.first).to eq places.first
					expect(@memory.tackles.first).to eq tackles.first
					expect(@memory.tackle_sets.first).to eq tackle_sets.first
				end
			end
		end
	end
=end

	describe "show" do
		let!(:user) { FactoryGirl.create( :user) }
		before {visit resource_path(user)}

		describe "panels" do
		  specify do
				expect(page).to have_selector('div.panel h3', text: I18n.t('fishing_memories.details'))
			end
		end

		describe "tables" do
			it "should have head" do
				expect(page).to have_selector('th', text: User.human_attribute_name("email"))
				expect(page).to have_selector('th', text: User.human_attribute_name("username"))
				expect(page).to have_selector('th', text: User.human_attribute_name("role"))
				expect(page).to have_selector('th', text: Memory.human_attribute_name("count"))
			end

			it "should have body" do
				expect(page).to have_selector('td', text: user.email)
				expect(page).to have_selector('td', text: user.username)
				expect(page).to have_selector('td', text: user.role)
				expect(page).to have_selector('td', text: user.memories.count)
			end
		end

	end


	describe "edit" do
		let!(:user) { FactoryGirl.create(:user) }

		let(:submit) {I18n.t('fishing_memories.update_model', model: User.model_name.human)}
		before do
			visit edit_admin_user_path(user)
		end

		it { should have_field("user_email", with: user.email, disabled: true) }
		it { should have_field("user_username", with: user.username, disabled: true) }
		it { should have_select('user_role', :options => [""] + User.roles.keys )}

		describe "with valid information" do
			before do
				select "admin", :from => "user_role"
				click_button submit
				user.reload
			end 

			it "should contain right role" do
				expect(user.role).to eq "admin"
			end
		end

	end

end
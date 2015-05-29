require 'spec_helper'
require "requests/shared_examples/resource_pages"
require "requests/shared_examples/resource_with_name_pages"
require "requests/shared_examples/sorted_table"
require "requests/shared_examples/filter"
require "requests/shared_examples/related_memories"

shared_context "ordered places" do
	let!(:first) { FactoryGirl.create(:place, user: user, name: 'a') }
	let!(:second) { FactoryGirl.create(:place, user: user, name: 'b') }
	let!(:third) { FactoryGirl.create(:place, user: user, name: 'c') }
	let!(:other) { FactoryGirl.create(:place) }
end

shared_context "ordered ponds" do
	let!(:first_pond) { FactoryGirl.create("pond", user: user, name: "a") }
	let!(:second_pond) { FactoryGirl.create("pond", user: user, name: "b") }
	let!(:third_pond) { FactoryGirl.create("pond", user: user, name: "c") }
end

describe "PlacesPages" do
	let(:resource_class) { Place }

	it_should_behave_like "resource pages" 

	it_should_behave_like "resource with name pages"

	include_context "login user"

	describe "index" do
		let!(:places) { FactoryGirl.create_list(:place_with_pond, 3, user: user) }
		before {visit places_path}

		it "should have table" do
			expect(page).to have_selector('th', text: Place.human_attribute_name("pond"))
		end

		it "should have content in table" do
			places.each do |place|
				expect(page).to have_link(place.pond.name, href: pond_path(place.pond))
			end
		end

		describe "sorting" do
			before { resource_class.delete_all }

			context do
				include_context "ordered places"
				include_context "ordered ponds"
				before do
					first.update_attribute(:pond_id, first_pond.id)
					second.update_attribute(:pond_id, second_pond.id)
					third.update_attribute(:pond_id, third_pond.id)
					visit polymorphic_path(resource_class)
				end
				it_should_behave_like "sorted table", sorted_column: "pond" 

			end
		end

		describe "filter" do

			before do
				resource_class.delete_all
				Pond.delete_all
			end

			include_context "ordered places"
			include_context "ordered ponds"

			context "by pond" do
				before do
					first.update_attribute(:pond_id, first_pond.id)
					second.update_attribute(:pond_id, second_pond.id)
					visit polymorphic_path(resource_class)
				end
				let(:first_associated) {first_pond}
				let(:second_associated) {second_pond}
				let(:third_associated) {third_pond}
				it_should_behave_like "filter by association", "pond"
			end

		end

	end

	describe "create" do
		let(:submit) {I18n.t('fishing_memories.new_model', model: Place.model_name.human)}
		let!(:ponds) { FactoryGirl.create_list(:pond, 3, user: user) }

		describe "select" do
			let(:other_user) { FactoryGirl.create(:confirmed_user) }
			let!(:other_user_ponds) { FactoryGirl.create_list(:pond, 3, user: other_user) }
			before {visit new_place_path}

			context "ponds" do
				it { should have_select('place[pond_id]', :options => [""] + ponds.map { |e| e.name}.sort) }
			end

		end

		describe "with valid information" do
			before do
				@name = "Шлюз"
				visit new_place_path
				select ponds.first.name, :from => "place[pond_id]"
				fill_in "place_name", with: @name
			end
			it "should create a place" do
				expect { click_button submit }.to change(Place, :count).by(1)
			end

			context 'place' do
				before do
					click_button submit
					@place = Place.order("created_at").last
				end
				it "should have selected fields" do
					expect(@place.name).to eq @name
					expect(@place.pond).to eq ponds.first
				end
			end

			describe "success messages" do
				before { click_button submit }
				it { should have_success_message(I18n.t('fishing_memories.model_created', model: Place.model_name.human)) }
			end
		end
	end

	describe "show" do
		let!(:place) { FactoryGirl.create(:place_with_pond, user: user) }
		before {visit place_path(place)}

		describe "panels" do
			specify do
				expect(page).to have_selector('div.panel h3', text: I18n.t('fishing_memories.details'))
			end
		end

		describe "tables" do
			it "should have head" do
				expect(page).to have_selector('th', text: Place.human_attribute_name("pond"))
			end

			it "should have body" do
				expect(page).to have_link(place.pond.title, href: pond_path(place.pond))
			end
		end

		describe "related memories" do
			let!(:place_memories) { FactoryGirl.create_list(:memory, 3, user: user, occured_at: Date.today.to_date) }
			let!(:place) { FactoryGirl.create(:place, user: user, memories: place_memories) }

			it_should_behave_like "table with related memories" do
				let!(:memories) {place.memories}
				let!(:other_memories) { FactoryGirl.create_list(:memory, 3, user: user, occured_at: Date.yesterday.to_date) }
				before {visit place_path(place)}
			end
		end

	end

	describe "edit" do
		let!(:place) { FactoryGirl.create(:place, user: user) }
		let!(:ponds) {FactoryGirl.create_list(:pond, 2, user: user)}
		let(:submit) {I18n.t('fishing_memories.update_model', model: Place.model_name.human)}
		before do
			visit edit_place_path(place)
			place.pond = ponds.first
		end

		describe "with valid information" do
			before do
				@name = "Комплект"
				fill_in "place_name", with: @name
				select ponds.second.name, :from => "place[pond_id]"
				click_button submit
				place.reload
			end 

			it "should contain right ponds" do
				expect(place.pond).to eq ponds.second
			end
		end

	end

end

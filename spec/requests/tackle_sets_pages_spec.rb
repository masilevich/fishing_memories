require 'spec_helper'
require 'user_helper'
require "requests/shared_examples/resource_pages"
require "requests/shared_examples/resource_with_name_pages"
require "requests/shared_examples/categorizable_pages"
require "requests/shared_examples/related_memories"

shared_context "ordered tackle sets" do
	let!(:first) { FactoryGirl.create(:tackle_set, user: user, name: 'a') }
	let!(:second) { FactoryGirl.create(:tackle_set, user: user, name: 'b') }
	let!(:third) { FactoryGirl.create(:tackle_set, user: user, name: 'c') }
	let!(:other) { FactoryGirl.create(:tackle_set) }
end

describe "TackleSetsPages" do
	let(:resource_class) { TackleSet }

	it_should_behave_like "resource pages" 

	it_should_behave_like "resource with name pages"

	it_should_behave_like "categorizable pages"

	include_context "login user"

	describe "index" do
		let!(:tackle_sets) { FactoryGirl.create_list(:tackle_set_with_tackles, 3, user: user) }
		before {visit tackle_sets_path}

		it "should have table" do
			expect(page).to have_selector('th', text: TackleSet.human_attribute_name("tackles"))
		end

		it "should have content in table" do
			tackle_sets.each do |tackle_set|
				tackle_set.tackles.each { |tackle|  expect(page).to have_link(tackle.name, href: tackle_path(tackle))}
			end
		end

		describe "sorting" do
			before { TackleSet.delete_all	}
			include_context "ordered tackle sets"					

			describe "HABTM" do
				before {visit polymorphic_path(resource_class)}
				it_should_behave_like "sorted table", sorted_column: "tackles" do
					let!(:first_associated) { FactoryGirl.create(:tackle, user: user, tackle_sets: [first], name: "a") }
					let!(:second_associated) { FactoryGirl.create(:tackle, user: user, tackle_sets: [second], name: "b") }
					let!(:third_associated) { FactoryGirl.create(:tackle, user: user, tackle_sets: [third], name: "c") }
				end
			end

		end

		describe "filter" do

			include_context "ordered tackle sets"

			describe "HABTM" do
				context "tackles" do
					it_should_behave_like "filter by HABTM association", "tackles" do
						let!(:first_associated) { FactoryGirl.create(:tackle, user: user, tackle_sets: [first, second], name: "a") }
						let!(:second_associated) { FactoryGirl.create(:tackle, user: user, tackle_sets: [first], name: "b") }
						let!(:third_associated) { FactoryGirl.create(:tackle, user: user, name: "c") }
						before {visit tackle_sets_path}
					end
				end
			end

		end
	end

	describe "create" do
		let(:submit) {I18n.t('fishing_memories.new_model', model: TackleSet.model_name.human)}

		describe "select" do
			let!(:tackles) { FactoryGirl.create_list(:tackle, 3, user: user) }
			let(:other_user) { FactoryGirl.create(:confirmed_user) }
			let!(:other_user_tackles) { FactoryGirl.create_list(:tackle, 3, user: other_user) }
			before {visit new_tackle_set_path}

			context "tackles" do
				it { should have_select('tackle_set[tackle_ids][]', :options => tackles.map { |e| e.name}.sort) }
			end

		end

		describe "with valid information" do
			let!(:tackle) { FactoryGirl.create(:tackle, user: user) }
			before do
				@name = "Комплект"
				visit new_tackle_set_path
				select tackle.name, :from => "tackle_set[tackle_ids][]"
				fill_in "tackle_set_name", with: @name
			end
			it "should create a tackle_set" do
				expect { click_button submit }.to change(TackleSet, :count).by(1)
			end

			context 'tackle_set' do
				before do
					click_button submit
					@tackle_set = TackleSet.order("created_at").last
				end
				it "should have selected fields" do
					expect(@tackle_set.name).to eq @name
					expect(@tackle_set.tackles.first).to eq tackle
				end
			end

			describe "success messages" do
				before { click_button submit }
				it { should have_success_message(I18n.t('fishing_memories.model_created', model: TackleSet.model_name.human)) }
			end
		end
	end

	describe "show" do
		let!(:tackle_set) { FactoryGirl.create(:tackle_set_with_tackles, user: user) }
		before {visit tackle_set_path(tackle_set)}

		describe "panels" do
			specify do
				expect(page).to have_selector('div.panel h3', text: I18n.t('fishing_memories.details'))
			end
		end

		describe "tables" do
			it "should have head" do
				expect(page).to have_selector('th', text: TackleSet.human_attribute_name("tackles"))
			end

			it "should have body" do
				tackle_set.tackles.each { |tackle|  expect(page).to have_link(tackle.title, href: tackle_path(tackle))}
			end
		end

		describe "related memories" do
			let!(:tackle_set_memories) { FactoryGirl.create_list(:memory, 3, user: user, occured_at: Date.today.to_date) }
			let!(:tackle_set) { FactoryGirl.create(:tackle_set, user: user, memories: tackle_set_memories) }

			it_should_behave_like "table with related memories" do
				let!(:memories) {tackle_set.memories}
				let!(:other_memories) { FactoryGirl.create_list(:memory, 3, user: user, occured_at: Date.yesterday.to_date) }
				before {visit tackle_set_path(tackle_set)}
			end
		end

	end


	describe "edit" do
		let!(:tackle_set) { FactoryGirl.create(:tackle_set, user: user) }
		let!(:tackles) {FactoryGirl.create_list(:tackle, 2, user: user)}
		let(:submit) {I18n.t('fishing_memories.update_model', model: TackleSet.model_name.human)}
		before do
			visit edit_tackle_set_path(tackle_set)
			tackle_set.tackles << tackles.first
		end

		describe "with valid information" do
			before do
				@name = "Комплект"
				fill_in "tackle_set_name", with: @name
				select tackles.second.name, :from => "tackle_set[tackle_ids][]"
				click_button submit
				tackle_set.reload
			end 

			it "should contain right tackles" do
				expect(tackle_set.tackles).to include(tackles.second)
				expect(tackle_set.tackles).to_not include(tackles.first)
			end
		end

	end

end

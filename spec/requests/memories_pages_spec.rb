require 'spec_helper'
require 'user_helper'
require 'active_support/core_ext/string/filters'
require "requests/shared_examples/resource_pages"
require "requests/shared_examples/filter"
require "requests/shared_examples/sorted_table"

shared_context "ordered memories" do
	let!(:first) { FactoryGirl.create(:memory, user: user, 
		description: 'a', occured_at: 2.day.ago) }
	let!(:second) { FactoryGirl.create(:memory, user: user, 
		description: 'b', occured_at: 1.day.ago) }
	let!(:third) { FactoryGirl.create(:memory, user: user, 
		description: 'c', occured_at: DateTime.now.to_date) }
	let!(:other) { FactoryGirl.create(:memory) }
end

describe "MemoriesPages" do

	let(:resource_class) { Memory }

	it_should_behave_like "resource pages" 

	include_context "login user"

	describe "index" do

		let!(:memories) { FactoryGirl.create_list(:memory_with_attributes, 2, user: user) }
		let!(:lond_desc_memory) { FactoryGirl.create(:memory, user: user, description: 'a'*100) }
		before {visit memories_path}

		describe "table" do

			it "should have header" do
				expect(page).to have_selector('th', text: Memory.human_attribute_name("occured_at"))
				expect(page).to have_selector('th', text: Memory.human_attribute_name("weather"))
				expect(page).to have_selector('th', text: Memory.human_attribute_name("description"))
				expect(page).to have_selector('th', text: Memory.human_attribute_name("tackles"))
				expect(page).to have_selector('th', text: Memory.human_attribute_name("ponds"))
				expect(page).to have_selector('th', text: Memory.human_attribute_name("places"))
			end

			it "should have content and action links" do
				memories.each do |memory|
					expect(page).to have_selector('td', text: memory.occured_at)
					expect(page).to have_selector('th', text: (memory.weather ? memory.weather.truncate(30) : "") )
					memory.ponds.each { |pond| expect(page).to have_link(pond.name, href: pond_path(pond)) }
					memory.places.each { |place| expect(page).to have_link(place.name, href: place_path(place)) }
					memory.tackles.each { |tackle| expect(page).to have_link(tackle.name, href: tackle_path(tackle))}
					expect(page).to have_selector('td', text: memory.description.truncate(70))
					expect(page).to have_link(I18n.t('fishing_memories.show'), href: memory_path(memory))
					expect(page).to have_link(I18n.t('fishing_memories.edit'), href: edit_memory_path(memory))
					expect(page).to have_link(I18n.t('fishing_memories.delete'), href: memory_path(memory))
				end
			end

			it "should have truncated description" do
				expect(page).to have_selector('td', text: lond_desc_memory.description.truncate(70))
			end

			describe "sorting" do
				
				before {Memory.delete_all}
				include_context "ordered memories"
				
				context do
					before {visit memories_path}
					
					it_should_behave_like "sorted table", sorted_column: "occured_at"

					it_should_behave_like "sorted table", sorted_column: "description"

					[Tackle, Pond, Place].each do |association_class|
						describe "HABTM" do
							context "#{association_class.model_name.plural}" do
								it_should_behave_like "sorted table", sorted_column: "#{association_class.model_name.plural}" do
									let!(:first_associated) { FactoryGirl.create(association_class, user: user, memories: [first], name: "a") }
									let!(:second_associated) { FactoryGirl.create(association_class, user: user, memories: [second], name: "b") }
									let!(:third_associated) { FactoryGirl.create(association_class, user: user, memories: [third], name: "c") }
								end
							end
						end
					end
				end
			end

		end

		describe "filter" do

			include_context "ordered memories"

			before {visit memories_path}

			it_should_behave_like "filter", occured_at: :range,  description: :cont,
			tackles: :association, ponds: :association, tackle_sets: :association
			
			[Tackle, Pond].each do |association_class|
				describe "HABTM" do
					context "#{association_class.model_name.plural}" do
						it_should_behave_like "filter by HABTM association", "#{association_class.model_name.plural}" do
							let!(:first_associated) { FactoryGirl.create( association_class, user: user, memories: [first, second], name: "a") }
							let!(:second_associated) { FactoryGirl.create( association_class, user: user, memories: [first], name: "b") }
							let!(:third_associated) { FactoryGirl.create( association_class, user: user, name: "c") }
							before {visit memories_path}
						end
					end
				end
			end

		end

	end

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
				end
			end
		end
	end

	describe "show" do
		let!(:memory) { FactoryGirl.create(:memory_with_attributes, user: user) }
		before {visit memory_path(memory)}

		describe "panels" do
		  specify do
				expect(page).to have_selector('div.panel h3', text: I18n.t('fishing_memories.details'))
				expect(page).to have_selector('div.panel h3', text: Memory.human_attribute_name("description"))
				expect(page).to have_selector('div.panel h3', text: Memory.human_attribute_name("conclusion"))
			end
		end

		describe "tables" do
			it "should have head" do
				expect(page).to have_selector('th', text: Memory.human_attribute_name("occured_at"))
				expect(page).to have_selector('th', text: Memory.human_attribute_name("weather"))
				expect(page).to have_selector('th', text: Memory.human_attribute_name("pond_state"))
				expect(page).to have_selector('th', text: Memory.human_attribute_name("tackles"))
				expect(page).to have_selector('th', text: Memory.human_attribute_name("ponds"))
				expect(page).to have_selector('th', text: Memory.human_attribute_name("places"))
			end

			it "should have body" do
				expect(page).to have_selector('td', text: memory.occured_at)
				expect(page).to have_selector('td', text: memory.weather)
				expect(page).to have_selector('tr', text: memory.description.truncate(90))
				memory.tackles.each { |tackle|  expect(page).to have_link(tackle.title, href: tackle_path(tackle))}
				memory.tackle_sets.each { |tackle_set|  expect(page).to have_link(tackle_set.title, href: tackle_set_path(tackle_set))}
				memory.ponds.each { |pond|  expect(page).to have_link(pond.title, href: pond_path(pond))}
				memory.places.each { |place|  expect(page).to have_link(place.title, href: place_path(place))}
			end
		end

		describe "memory with links" do
			before do
			  memory.update_attribute(:description, "this is text with link http://example.com/auto_link_test")
			  visit memory_path(memory)
			end
			it "should auto_link text" do
				expect(page).to have_link("http://example.com/auto_link_test", href: "http://example.com/auto_link_test")
			end
		end

	end

	describe "edit" do
		let!(:memory) { FactoryGirl.create(:memory, user: user) }
		let!(:tackles) {FactoryGirl.create_list(:tackle, 2, user: user)}
		let!(:tackle_sets) {FactoryGirl.create_list(:tackle_set, 2, user: user)}
		let!(:ponds) {FactoryGirl.create_list(:pond, 2, user: user)}
		let!(:places) {FactoryGirl.create_list(:place, 2, user: user, pond: ponds.first)}
		let!(:place_without_pond) { FactoryGirl.create(:place, user: user) }
		let(:submit) {I18n.t('fishing_memories.update_model', model: Memory.model_name.human)}
		before do
			memory.ponds << ponds.first
			memory.tackles << tackles.first
			memory.tackle_sets << tackle_sets.first
			memory.places << places.first
			memory.save
			visit edit_memory_path(memory)
		end

		it { should have_field("memory_occured_at", with: memory.occured_at.strftime('%d.%m.%Y')) }
		it { should have_field("memory_description", with: memory.description) }
		it { should have_select('memory[pond_ids][]', :options => ponds.map { |e| e.name}.sort,
			selected: ponds.first.name )}
		it { should have_select('memory[place_ids][]',
			with_options:user.places.map { |e| e.name}.sort, selected: places.first.name ) }
		it { should have_select('memory[tackle_ids][]', :options => tackles.map { |e| e.name}.sort, 
			selected: tackles.first.name)}


		describe "with valid information" do
			before do
				@new_occured_at = DateTime.now.to_date
				fill_in "memory_occured_at", with: @new_occured_at
				select tackles.second.name, :from => "memory[tackle_ids][]"
				select ponds.second.name, :from => "memory[pond_ids][]"
				select places.second.name, :from => "memory[place_ids][]"
				click_button submit
				memory.reload
			end 
			it "should update a memory date" do
				expect(memory.occured_at).to eq @new_occured_at
			end

			it "should contain right ponds" do
				expect(memory.ponds).to include(ponds.second)
				expect(memory.ponds).to include(ponds.first)
			end

			it "should contain right places" do
				expect(memory.places).to include(places.second)
				expect(memory.places).to include(places.first)
			end

			it "should contain right tackles" do
				expect(memory.tackles).to include(tackles.second)
				expect(memory.tackles).to include(tackles.first)
			end

		end

	end
end
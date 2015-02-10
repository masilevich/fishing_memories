require 'spec_helper'
require 'user_helper'

shared_context "ordered resources" do
	let(:singular_resource_name) {resource_class.model_name.singular}
	before do
		resource_class.delete_all
	end
	let!(:first) { FactoryGirl.create(:"#{singular_resource_name}", user: user, 
		name: 'a') }
	let!(:second) { FactoryGirl.create(:"#{singular_resource_name}", user: user, 
		name: 'b') }
	let!(:third) { FactoryGirl.create(:"#{singular_resource_name}", user: user, 
		name: 'c') }
end

shared_examples "resource with name pages"  do
	include_context "login user"

	shared_context 'resource_item' do 
		let!(:resource_item) {FactoryGirl.create(:"#{resource_class.model_name.singular}", user: user)}
	end

	describe "index" do
		let!(:resources) { FactoryGirl.create_list(:"#{resource_class.model_name.singular}", 3, user: user) }
		before {visit polymorphic_path(resource_class)}

		describe "table" do

			it "should have header" do
				expect(page).to have_selector('th', text: resource_class.human_attribute_name("name"))
			end

			it "should have content and links in table" do
				resources.each do |resource_item|
					expect(page).to have_selector('td', text: resource_item.name)
					expect(page).to have_link(I18n.t('fishing_memories.show'), href: polymorphic_path(resource_item))
					expect(page).to have_link(I18n.t('fishing_memories.edit'), href: edit_polymorphic_path(resource_item))
					expect(page).to have_link(I18n.t('fishing_memories.delete'), polymorphic_path(resource_item))
				end
			end

			describe "sorting" do
				include_context "ordered resources"

				it_should_behave_like "sorted_table" do
					let!(:sorted_column) { "name" }
				end
				
			end
		end

		describe "filter" do

			include_context "ordered resources"

			it_should_behave_like "filter", {name: :cont}

		end

	end

	describe "create" do
		let(:submit) {I18n.t('fishing_memories.new_model', model: resource_class.model_name.human)}
		before {visit new_polymorphic_path(resource_class)}

		describe "with valid information" do
			before {fill_in "#{resource_class.model_name.singular}_name", with: "Рыболовная снасть" }
			it "should create a resource" do
				expect { click_button submit }.to change(resource_class, :count).by(1)
			end

			describe "success messages" do
				before { click_button submit }
				it { should have_success_message(I18n.t('fishing_memories.model_created', model: resource_class.model_name.human)) }
			end
		end
	end

	describe "show" do
		include_context 'resource_item'
		before {visit polymorphic_path(resource_item)}

		describe "panels" do
			specify do
				expect(page).to have_selector('div.panel h3', text: I18n.t('fishing_memories.details'))
			end
		end

		describe "tables" do
			it "should have head" do
				expect(page).to have_selector('th', text: resource_class.human_attribute_name("name"))
			end

			it "should have body" do
				expect(page).to have_selector('td', text: resource_item.name)
			end
		end
		
	end

	describe "edit" do
		include_context 'resource_item'
		let(:submit) {I18n.t('fishing_memories.update_model', model: resource_class.model_name.human)}
		before {visit edit_polymorphic_path(resource_item)}

		it { should have_field("#{resource_class.model_name.singular}_name", with: resource_item.name) }

		describe "with valid information" do
			before do
				@new_name = "Новое название"
				fill_in "#{resource_class.model_name.singular}_name", with: @new_name
				click_button submit
				resource_item.reload
			end 
			it "should update a resource" do
				expect(resource_item.name).to eq @new_name
			end

			
		end
	end
end

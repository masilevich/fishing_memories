require 'spec_helper'
require 'user_helper'

shared_examples "categorizable pages"  do
	include_context "login user"

	let!(:category) {FactoryGirl.create(:"#{resource_class.model_name.singular}_category", user: user)}
	let(:single_resource_name) {resource_class.model_name.singular}

	shared_examples "resource_item" do
	  let!(:resource_item) {FactoryGirl.create(:"#{resource_class.model_name.singular}", 
			user: user, category: category)}
	end

	describe "index" do
		include_context 'resource_item'
		before {visit polymorphic_path(resource_class)}

		describe "table" do

			it "should have header" do
				expect(page).to have_selector('th', text: resource_class.human_attribute_name("category"))
			end

			it "should have content and links in table" do
				expect(page).to have_selector('td', text: resource_item.category.name)
			end

=begin
			describe "sorting" do
				include_context "ordered resources"

				it_should_behave_like "sorted_table" do
					let!(:sorted_column) { "category_" }
				end

			end
=end

		end

=begin
		describe "filter" do

			include_context "ordered resources"

			it_should_behave_like "filter", {name: :cont}

		end

=end
	end


	describe "create" do
		let(:submit) {I18n.t('fishing_memories.new_model', model: resource_class.model_name.human)}
		before {visit new_polymorphic_path(resource_class)}

		it "should have select category" do
		  expect(page).to have_select("#{single_resource_name}[category_id]", 
		  	:options => [""] + user.send("#{single_resource_name}_categories").map { |e| e.name}.sort)
		end

		describe "with valid information" do
			before do
			  fill_in "#{single_resource_name}_name", with: "Рыболовная снасть"
			  select category.name, :from => "#{single_resource_name}[category_id]"
			  click_button submit
			  @resource = resource_class.order("created_at").last
			end 

			it "should have category" do
			  expect(@resource.category).to eq category
			end

		end
	end


	describe "show" do
		include_context 'resource_item'
		before {visit polymorphic_path(resource_item)}

		describe "tables" do
			it "should have head" do
				expect(page).to have_selector('th', text: resource_class.human_attribute_name("category"))
			end

			it "should have body" do
				expect(page).to have_selector('td', text: resource_item.category.name)
			end
		end

	end

	describe "edit" do
		include_context 'resource_item'
		let!(:other_category) {FactoryGirl.create(:"#{resource_class.model_name.singular}_category", user: user)}
		let(:submit) {I18n.t('fishing_memories.update_model', model: resource_class.model_name.human)}
		before {visit edit_polymorphic_path(resource_item)}

		describe "with valid information" do
			before do
				select other_category.name, :from => "#{single_resource_name}[category_id]"
				click_button submit
				resource_item.reload
			end 
			it "should update a resource" do
				expect(resource_item.category).to eq other_category
			end
		end
	end

end

require 'spec_helper'
require 'user_helper'

shared_context "ordered resources for categories" do
	let!(:first) { FactoryGirl.create(resource_class, user: user) }
	let!(:second) { FactoryGirl.create(resource_class, user: user) }
	let!(:third) { FactoryGirl.create(resource_class, user: user) }
end

shared_context "ordered categories" do
	let!(:first_category) { FactoryGirl.create("#{singular_resource_name}_category", user: user, name: "a") }
	let!(:second_category) { FactoryGirl.create("#{singular_resource_name}_category", user: user, name: "b") }
	let!(:third_category) { FactoryGirl.create("#{singular_resource_name}_category", user: user, name: "c") }
end



shared_examples "categorizable pages"  do

	include_context "login user"

	let!(:category) {FactoryGirl.create("#{singular_resource_name}_category", user: user)}
	

	shared_examples "resource_item" do
		let!(:resource_item) {FactoryGirl.create(singular_resource_name, 
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
				expect(page).to have_link(resource_item.category.name, href: polymorphic_path(resource_item.category))
			end

			describe "sorting" do
				before { resource_class.delete_all }
				
				context do
					include_context "ordered resources for categories"
					include_context "ordered categories"
					before do
						first.update_attribute(:category_id, first_category.id)
						second.update_attribute(:category_id, second_category.id)
						third.update_attribute(:category_id, third_category.id)
						visit polymorphic_path(resource_class)
					end
					it_should_behave_like "sorted table", sorted_column: "category" 

				end
			end

		end

		describe "filter" do

			before do
				resource_class.delete_all
				Category.delete_all
			end

			include_context "ordered resources for categories"
			include_context "ordered categories"

			context "by category" do
				before do
					first.update_attribute(:category_id, first_category.id)
					second.update_attribute(:category_id, second_category.id)
					visit polymorphic_path(resource_class)
				end
				let(:first_associated) {first_category}
				let(:second_associated) {second_category}
				let(:third_associated) {third_category}
				it_should_behave_like "filter by association", "category"
			end
		end

	end


	describe "create" do
		let(:submit) {I18n.t('fishing_memories.new_model', model: resource_class.model_name.human)}
		before {visit new_polymorphic_path(resource_class)}

		it "should have select category" do
			expect(page).to have_select("#{singular_resource_name}[category_id]", 
				:options => [""] + user.send("#{singular_resource_name}_categories").map { |e| e.name}.sort)
		end

		describe "with valid information" do
			before do
				fill_in "#{singular_resource_name}_name", with: "Рыболовная снасть"
				select category.name, :from => "#{singular_resource_name}[category_id]"
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
				expect(page).to have_link(resource_item.category.name, href: polymorphic_path(resource_item.category))
			end
		end

	end

	describe "edit" do
		include_context 'resource_item'
		let!(:other_category) {FactoryGirl.create("#{singular_resource_name}_category", user: user)}
		let(:submit) {I18n.t('fishing_memories.update_model', model: resource_class.model_name.human)}
		before {visit edit_polymorphic_path(resource_item)}

		describe "with valid information" do
			before do
				select other_category.name, :from => "#{singular_resource_name}[category_id]"
				click_button submit
				resource_item.reload
			end 
			it "should update a resource" do
				expect(resource_item.category).to eq other_category
			end
		end
	end

end

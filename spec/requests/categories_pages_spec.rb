require 'spec_helper'
require "category_helpers"
require 'user_helper'
require "requests/shared_examples/resource_pages"
require "requests/shared_examples/resource_with_name_pages"

shared_examples "category related resources table" do
	it "should have head" do
		expect(page).to have_selector('th', text: I18n.t("fishing_memories.category_related_resources", 
			resources: resource_class.human_attribute_name(resource_class.related_resources_plural_name)))
	end

	it "should have content and links" do
		related_resources.each do |resource|
			expect(page).to have_selector('td', text: resource.title)
			expect(page).to have_link(I18n.t('fishing_memories.show'), href: polymorphic_path(resource))
			expect(page).to have_link(I18n.t('fishing_memories.edit'), href: edit_polymorphic_path(resource))
			expect(page).to have_link(I18n.t('fishing_memories.delete'), href: polymorphic_path(resource))
		end
	end

	it "should not have other memories" do
		other_resources.each do |resource|
			expect(page).to_not have_selector('td', text: resource.title)
		end
	end
end

describe "CategoriesPages" do
	include_context "category helpers"
	include_context "login user"

	CATEGORY_TYPES.each do |type|

		describe "{type}" do
			let(:resource_class) { typeable_category_class(type) }

			it_should_behave_like "resource pages" 

			it_should_behave_like "resource with name pages" 

			describe "show" do
				describe "related resources" do
					let!(:category) { FactoryGirl.create(resource_class, user: user) }
					let!(:related_resources) { FactoryGirl.create_list(resource_class.related_resources_single_name, 
						3, user: user, category: category) }
					let!(:other_resources) { FactoryGirl.create_list(resource_class.related_resources_single_name, 
						3, user: user) }
					before {visit polymorphic_path(category)}

					it_should_behave_like "category related resources table"

				end
			end
		end
		
	end

end


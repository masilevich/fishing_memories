require 'spec_helper'
require "category_helper"
require 'user_helper'

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

describe "categories_pages" do
	include_context "category helper"
	include_context "login user"

	CATEGORY_TYPES.each do |type|

		describe "{type}" do
			let(:resource_class) { category_class(type) }

			it_should_behave_like "resource pages" 

			it_should_behave_like "resource with name pages" 

			describe "show" do
				describe "related related_resources" do
					let!(:category) { FactoryGirl.create(:"#{category_single_name(type)}", user: user) }
					let!(:related_resources) { FactoryGirl.create_list(:"#{related_resource_class_single_name(type)}", 
						3, user: user, category: category) }
					let!(:other_resources) { FactoryGirl.create_list(:"#{related_resource_class_single_name(type)}", 
						3, user: user) }
					before {visit polymorphic_path(category)}

					it_should_behave_like "category related resources table"

				end
			end
		end
		
	end

end


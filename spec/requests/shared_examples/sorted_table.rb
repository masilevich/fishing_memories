shared_examples "sorted_table" do

	describe "by " do
		let(:singular_resource) {resource_class.model_name.singular}
		before do
			visit polymorphic_path(resource_class)
			click_link(resource_class.human_attribute_name(column))
		end
		specify do
			expect(page).to have_selector("tr:first-child##{singular_resource}_#{first.id}")
			expect(page).to have_selector("tr:nth-child(2)##{singular_resource}_#{second.id}")
			expect(page).to have_selector("tr:nth-child(3)##{singular_resource}_#{third.id}")
			click_link(resource_class.human_attribute_name(column))
			expect(page).to have_selector("tr:first-child##{singular_resource}_#{third.id}")
			expect(page).to have_selector("tr:nth-child(2)##{singular_resource}_#{second.id}")
			expect(page).to have_selector("tr:nth-child(3)##{singular_resource}_#{first.id}")							
		end
	end

end
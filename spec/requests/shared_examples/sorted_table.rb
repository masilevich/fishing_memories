shared_examples "sorted table" do |options={}|

	describe "by #{options[:sorted_column]}" do
		let(:singular_resource) {resource_class.model_name.singular}
		before do
			within ("#main_content") {click_link(resource_class.human_attribute_name(options[:sorted_column]))}
		end
		specify do
			expect(page).to have_selector("tr:first-child##{singular_resource}_#{first.id}")
			expect(page).to have_selector("tr:nth-child(2)##{singular_resource}_#{second.id}")
			expect(page).to have_selector("tr:nth-child(3)##{singular_resource}_#{third.id}")
			within ("#main_content") {click_link(resource_class.human_attribute_name(options[:sorted_column]))}
			expect(page).to have_selector("tr:first-child##{singular_resource}_#{third.id}")
			expect(page).to have_selector("tr:nth-child(2)##{singular_resource}_#{second.id}")
			expect(page).to have_selector("tr:nth-child(3)##{singular_resource}_#{first.id}")							
		end
	end

end
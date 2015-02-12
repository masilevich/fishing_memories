shared_examples "sorted table" do |options={}|

	describe "by #{options[:sorted_column]}" do
		before do
			within ("#main_content") {click_link(resource_class.human_attribute_name(options[:sorted_column]))}
		end
		specify do
			expect(page).to have_selector("tr:first-child##{singular_resource_name}_#{first.id}")
			expect(page).to have_selector("tr:nth-child(2)##{singular_resource_name}_#{second.id}")
			expect(page).to have_selector("tr:nth-child(3)##{singular_resource_name}_#{third.id}")
			within ("#main_content") {click_link(resource_class.human_attribute_name(options[:sorted_column]))}
			expect(page).to have_selector("tr:first-child##{singular_resource_name}_#{third.id}")
			expect(page).to have_selector("tr:nth-child(2)##{singular_resource_name}_#{second.id}")
			expect(page).to have_selector("tr:nth-child(3)##{singular_resource_name}_#{first.id}")							
		end
	end

end
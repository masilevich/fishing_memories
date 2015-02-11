shared_context "filter context" do
	let(:submit) { I18n.t('ransack.search') }
	let(:singular_resource) {resource_class.model_name.singular}
end

shared_examples "filter" do |columns = {}|

	include_context "filter context"

	it_should_behave_like "filter with title and actions"

	columns.each_pair do |name, type|
		case type
		when :range
			it_should_behave_like "filter by range field", name
		when :cont
			it_should_behave_like "filter by contains field", name
		end
	end

end

shared_examples "not found container" do
	it {should have_selector('div.blank_slate_container', 
		text: I18n.t('fishing_memories.model_not_found', model: (resource_class.model_name.human count: PLURAL_MANY_COUNT))) }
end

shared_examples "filter with title and actions" do

	it "should have title" do
		expect(page).to have_selector('div#sidebar h3', text: I18n.t('fishing_memories.sidebars.filters'))
	end

	it "should have actions" do
		within("#sidebar") do
			expect(page).to have_button(I18n.t('ransack.search'))
			expect(page).to have_link(I18n.t('ransack.clear'))
		end
	end
end

shared_examples "filter by range field" do |filter_column|
	describe "#{filter_column}" do
		include_context "filter context"
		context "great then" do
			before do
				fill_in "q[#{filter_column}_gteq]", with: third.send(filter_column)
				click_button submit
			end
			specify do
				expect(page).to have_selector("tr##{singular_resource}_#{third.id}")
				expect(page).to_not have_selector("tr##{singular_resource}_#{first.id}")
				expect(page).to_not have_selector("tr##{singular_resource}_#{second.id}")
			end
		end

		context "less then" do
			before do
				fill_in "q[#{filter_column}_lteq]", with: first.send(filter_column)
				click_button submit
			end
			specify do
				expect(page).to have_selector("tr##{singular_resource}_#{first.id}")
				expect(page).to_not have_selector("tr##{singular_resource}_#{third.id}")
				expect(page).to_not have_selector("tr##{singular_resource}_#{second.id}")
			end
		end

		context "in range" do
			before do
				fill_in "q[#{filter_column}_gteq]", with: first.send(filter_column)
				fill_in "q[#{filter_column}_lteq]", with: second.send(filter_column)
				click_button submit
			end
			specify do
				expect(page).to have_selector("tr##{singular_resource}_#{first.id}")
				expect(page).to have_selector("tr##{singular_resource}_#{second.id}")
				expect(page).to_not have_selector("tr##{singular_resource}_#{third.id}")
			end
		end

		context "resource not found" do
			before do
				fill_in "q[#{filter_column}_lteq]", with: first.send(filter_column)
				fill_in "q[#{filter_column}_gteq]", with: third.send(filter_column)
				click_button submit
			end

			it_should_behave_like "not found container"
		end
	end
end

shared_examples "filter by contains field" do |filter_column|
	describe "#{filter_column}" do
		include_context "filter context"

		context "finded resources" do
			before do
				fill_in "q[#{filter_column}_cont]", with: first.send(filter_column)
				click_button submit
			end
			specify do
				expect(page).to have_selector("tr##{singular_resource}_#{first.id}")
				expect(page).to_not have_selector("tr##{singular_resource}_#{third.id}")
				expect(page).to_not have_selector("tr##{singular_resource}_#{second.id}")
			end
		end

		context "resource not found" do
			before do
				fill_in "q[#{filter_column}_cont]", with: "not existed resource"
				click_button submit
			end

			it_should_behave_like "not found container"
		end

	end
end

shared_examples "filter by HABTM association" do |filter_column|
	describe "#{filter_column}" do

		it { should have_select("q[#{filter_column}_id_eq]", 
			:options => ["", first_associated.title, second_associated.title, third_associated.title ]) }

		describe "select" do
			include_context "filter context"

			context "first" do
				before do
					select first_associated.title, from: "q[#{filter_column}_id_eq]"
					click_button submit
				end

				specify do
					expect(page).to have_selector("tr##{singular_resource}_#{first.id}")
					expect(page).to have_selector("tr##{singular_resource}_#{second.id}")
					expect(page).to_not have_selector("tr##{singular_resource}_#{third.id}")
				end
			end

			context "second" do
				before do
					select second_associated.title, from: "q[#{filter_column}_id_eq]"
					click_button submit
				end

				specify do
					expect(page).to have_selector("tr##{singular_resource}_#{first.id}")
					expect(page).to_not have_selector("tr##{singular_resource}_#{second.id}")
					expect(page).to_not have_selector("tr##{singular_resource}_#{third.id}")
				end
			end

			context "third" do
				before do
					select third_associated.title, from: "q[#{filter_column}_id_eq]"
					click_button submit
				end

				it_should_behave_like "not found container"
			end
		end
	end
end

shared_examples "filter by association" do |filter_column|
	describe "#{filter_column}" do

		it { should have_select("q[#{filter_column}_id_eq]", 
			:options => ["", first_associated.title, second_associated.title, third_associated.title ]) }

		describe "select" do
			include_context "filter context"

			context "first" do
				before do
					select first_associated.title, from: "q[#{filter_column}_id_eq]"
					click_button submit
				end

				specify do
					expect(page).to have_selector("tr##{singular_resource}_#{first.id}")
					expect(page).to_not have_selector("tr##{singular_resource}_#{second.id}")
					expect(page).to_not have_selector("tr##{singular_resource}_#{third.id}")
				end
			end

			context "second" do
				before do
					select second_associated.title, from: "q[#{filter_column}_id_eq]"
					click_button submit
				end

				specify do
					expect(page).to_not have_selector("tr##{singular_resource}_#{first.id}")
					expect(page).to have_selector("tr##{singular_resource}_#{second.id}")
					expect(page).to_not have_selector("tr##{singular_resource}_#{third.id}")
				end
			end

			context "third" do
				before do
					select third_associated.title, from: "q[#{filter_column}_id_eq]"
					click_button submit
				end

				it_should_behave_like "not found container"
			end
		end
	end
end
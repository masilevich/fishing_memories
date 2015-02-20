require 'spec_helper'
require 'user_helper'

describe "ApplicationLayoutPages" do

	subject { page }

	describe "for signed-in user" do
		include_context "login user"
		before do 
			visit root_path
		end

		describe "header" do
			let(:tackle_tab_label) {Tackle.model_name.human count: PLURAL_MANY_COUNT}
			let(:tackle_sets_tab_label) {TackleSet.model_name.human count: PLURAL_MANY_COUNT}
			let(:memories_tab_label) {Memory.model_name.human count: PLURAL_MANY_COUNT}
			let(:ponds_tab_label) {Pond.model_name.human count: PLURAL_MANY_COUNT}
			let(:places_tab_label) {Place.model_name.human count: PLURAL_MANY_COUNT}
			let(:categories_tab_label) {Category.model_name.human count: PLURAL_MANY_COUNT}
			let(:tackle_categories_tab_label) {TackleCategory.model_name.human count: PLURAL_MANY_COUNT}
			describe "tabs" do

				describe "switch" do
					describe "to another tab" do

						describe "through click on tab" do

							describe "tackles" do
								before {click_link tackle_tab_label}
								it "should change current tab" do
									within "ul#tabs" do
										expect(page).to have_selector('li.current', text: tackle_tab_label)
									end	
								end
							end

							describe "tackle_sets" do
								before {click_link tackle_sets_tab_label}
								it "should change current tab" do
									within "ul#tabs" do
										expect(page).to have_selector('li.current', text: tackle_sets_tab_label)
									end	
								end
							end
							
							describe "ponds" do
								before {click_link ponds_tab_label}
								it "should change current tab" do
									within "ul#tabs" do
										expect(page).to have_selector('li.current', text: ponds_tab_label)
									end	
								end
							end

							describe "places" do
								before {click_link places_tab_label}
								it "should change current tab" do
									within "ul#tabs" do
										expect(page).to have_selector('li.current', text: ponds_tab_label)
									end	
								end
							end

							describe "categories" do
								before {click_link tackle_categories_tab_label}
								it "should change current tab" do
									within "ul#tabs" do
										expect(page).to have_selector('li.current', text: categories_tab_label)
									end	
								end
							end
						end

						describe "through visit another resource" do
							let(:tackle) {FactoryGirl.create(:tackle, user: user)}
							before {visit tackle_path(tackle)}
							it "should change current tab" do
								within "ul#tabs" do
									expect(page).to have_selector('li.current', text: tackle_tab_label)
								end	
							end
						end

					end
				end
			end
		end

		describe "title bar" do
			describe "on resource pages" do
				it { should have_selector('div#title_bar') }
			end

			describe "on static pages" do
				before {visit home_path}
				it { should_not have_selector('div#title_bar') }
			end
		end
	end

	describe "for signed-out user" do
		before do 
			visit root_path
		end

		describe "title bar" do
			it { should_not have_selector('div#title_bar') }
		end
	end
end

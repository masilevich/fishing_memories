require 'spec_helper'
require 'user_helper'

describe "ApplicationLayoutPages" do

	subject { page }

	describe "for signed-in" do
		context "user" do

			include_context "login user"
			before do 
				visit memories_path
			end

			describe "header" do
				let(:tackle_tab_label) {Tackle.model_name.human count: PLURAL_MANY_COUNT}
				let(:lures_tab_label) {Lure.model_name.human count: PLURAL_MANY_COUNT}
				let(:brands_tab_label) {Brand.model_name.human count: PLURAL_MANY_COUNT}
				let(:memories_tab_label) {Memory.model_name.human count: PLURAL_MANY_COUNT}
				let(:notes_tab_label) {Note.model_name.human count: PLURAL_MANY_COUNT}
				let(:ponds_tab_label) {Pond.model_name.human count: PLURAL_MANY_COUNT}
				let(:places_tab_label) {Place.model_name.human count: PLURAL_MANY_COUNT}
				let(:categories_tab_label) {Category.model_name.human count: PLURAL_MANY_COUNT}
				let(:tackle_categories_tab_label) {TackleCategory.model_name.human count: PLURAL_MANY_COUNT}

				describe "tabs" do
					describe "switch" do
						describe "through link click" do
							it "should switch active nav link" do
								click_link notes_tab_label
								within "ul#tabs" do
									expect(page).to have_selector('li.current', text: notes_tab_label)
								end
								click_link tackle_tab_label
								within "ul#tabs" do
									expect(page).to have_selector('li.current', text: tackle_tab_label)
								end
								click_link lures_tab_label
								within "ul#tabs" do
									expect(page).to have_selector('li.current', text: tackle_tab_label)
								end
								click_link brands_tab_label
								within "ul#tabs" do
									expect(page).to have_selector('li.current', text: tackle_tab_label)
								end
								click_link ponds_tab_label
								within "ul#tabs" do
									expect(page).to have_selector('li.current', text: ponds_tab_label)
								end	
								click_link places_tab_label
								within "ul#tabs" do
									expect(page).to have_selector('li.current', text: ponds_tab_label)
								end	
								click_link tackle_categories_tab_label
								within "ul#tabs" do
									expect(page).to have_selector('li.current', text: categories_tab_label)
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

		context "admin" do
			let(:users_tab_label) {User.model_name.human count: PLURAL_MANY_COUNT}
			include_context "login admin"
			before do
				visit admin_root_path
			end

			it "should have admin users current tab" do
				within "ul#tabs" do
					expect(page).to have_selector('li.current', text: users_tab_label)
				end	
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

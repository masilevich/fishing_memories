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
			describe "tabs" do
				it "should display tackles, ponds links" do
					within "#tabs" do
						expect(page).to have_link((Tackle.model_name.human count: PLURAL_MANY_COUNT), href: tackles_path)
						expect(page).to have_link((Pond.model_name.human count: PLURAL_MANY_COUNT), href: ponds_path)
					end
				end

				describe "switch" do
					describe "to another tab" do
						let(:tackle_tab_label) {Tackle.model_name.human count: PLURAL_MANY_COUNT}

						describe "through click on tab" do
							before {click_link tackle_tab_label}
							it "should change current tab" do
								within "ul#tabs" do
									expect(page).to have_selector('li.current', text: tackle_tab_label)
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
	end
end

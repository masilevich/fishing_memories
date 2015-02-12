require 'spec_helper'
require 'user_helper'

shared_examples "resource pages" do

	include_context "login user"

	shared_examples 'title and page_title' do
		it { should have_title(full_title(title)) }
		specify { expect(find('#page_title')).to have_content(title) }
	end

	shared_examples "back link" do
		specify { expect(page).to have_link(I18n.t("fishing_memories.back"), :back)  }
	end

	shared_examples "breadscrumb link" do |name, href|
		within ".breadcrumb" do
			specify { expect(page).to have_link(name, href)  }
		end
	end

	shared_context 'resource_item' do 
		let!(:resource_item) {FactoryGirl.create(resource_class, user: user)}
	end

	describe "index" do
		let(:title) { resource_class.model_name.human count: PLURAL_MANY_COUNT }
		before {visit polymorphic_path(resource_class)}

		it_behaves_like "title and page_title"

		describe "title links" do
			it { should have_link( I18n.t('fishing_memories.new_model', 
				model: resource_class.model_name.human), href: new_polymorphic_path(resource_class)) }
		end

		describe "pagination" do
			let!(:resource_items) { FactoryGirl.create_list(resource_class, 40, user: user) }
			before {visit polymorphic_path(resource_class)}

			it { should have_selector('nav.pagination') }

			describe "links" do
				it { should have_link(I18n.t('views.pagination.last').clear) }
				it { should have_link(I18n.t('views.pagination.next').clear) }
				it { should have_link('2') }
			end

			let(:user_resources) { user.send(resource_class.model_name.plural) }
			describe "pages" do
				context "first" do
					specify do
						user_resources.page(1).each do |resource_item|
							expect(page).to have_link(I18n.t('fishing_memories.show'), 
								href: polymorphic_path(resource_item))
						end
					end
				end

				context 'second' do
					before {click_link '2'}
					specify do
						user_resources.page(2).each do |resource_item|
							expect(page).to have_link(I18n.t('fishing_memories.show'), 
								href: polymorphic_path(resource_item))
						end
					end

					it { should have_link(I18n.t("views.pagination.first").clear) }
					it { should have_link("1") }
				end
			end
		end
	end

	describe "create" do
		let(:title) { I18n.t('fishing_memories.new_model', model: resource_class.model_name.human) }
		let(:submit) {I18n.t('fishing_memories.new_model', model: resource_class.model_name.human)}
		before {visit new_polymorphic_path(resource_class)}

		it_behaves_like "title and page_title"
		it_behaves_like "back link"

		it { should have_button(submit) }

		describe "with invalid information" do

			it "should not create a resource" do
				expect { click_button submit }.not_to change(resource_class, :count)
			end

			describe "error messages" do
				before { click_button submit }
				it { should have_error_message(I18n.t('fishing_memories.model_not_created', model: resource_class.model_name.human)) }
			end
		end
	end

	describe "destruction"  do
		let(:delete_link) { I18n.t('fishing_memories.delete') }
		include_context 'resource_item'
		describe "on index" do

			before { visit polymorphic_path(resource_class.model_name.plural) }

			it "should delete resource" do
				expect { click_link delete_link }.to change(resource_class, :count).by(-1)
			end

			describe "should have link to destroy" do
				specify {expect(page).to have_link(delete_link, polymorphic_path(resource_item))}
			end
		end

		describe "on show" do

			before { visit polymorphic_path(resource_item) }

			it "should delete resource" do
				expect { click_link delete_link }.to change(resource_class, :count).by(-1)
			end

			describe "should have link to destroy" do
				specify {expect(page).to have_link(delete_link, polymorphic_path(resource_item))}
			end

			describe "success messages" do
				before { click_link delete_link }
				it { should have_success_message(I18n.t('fishing_memories.model_destroyed', model: resource_class.model_name.human)) }
			end
		end
	end

	describe "show" do
		include_context 'resource_item'
		let(:title) { resource_item.title }
		before {visit polymorphic_path(resource_item)}

		it_behaves_like "title and page_title"

		describe "title links" do
			it { should have_link( I18n.t('fishing_memories.edit_model', 
				model: resource_class.model_name.human), href: edit_polymorphic_path(resource_item)) }
			it { should have_link( I18n.t('fishing_memories.destroy_model', 
				model: resource_class.model_name.human), href: polymorphic_path(resource_item)) }
		end

		describe "breadscrumbs links" do
			specify do
				within('#titlebar_left') do
					expect(page).to have_link( resource_class.model_name.human count: PLURAL_MANY_COUNT,
						href: polymorphic_path(resource_class))
				end
			end
		end

	end

	describe "edit" do
		include_context 'resource_item'
		let(:title) { I18n.t('fishing_memories.edit_model', model: resource_class.model_name.human) }
		let(:submit) {I18n.t('fishing_memories.update_model', model: resource_class.model_name.human)}
		before {visit edit_polymorphic_path(resource_item)}

		it_behaves_like "title and page_title"
		it_behaves_like "back link"

		it { should have_button(submit) }

		describe "success messages" do
			before { click_button submit }
			it { should have_success_message(I18n.t('fishing_memories.model_updated', model: resource_class.model_name.human)) }
		end

		describe "breadscrumbs links" do
			specify do
				within('#titlebar_left') do
					expect(page).to have_link( resource_class.model_name.human count: PLURAL_MANY_COUNT,
						href: polymorphic_path(resource_class))
					expect(page).to have_link( resource_item.title,
						href: polymorphic_path(resource_item))
				end
			end
		end
	end


end

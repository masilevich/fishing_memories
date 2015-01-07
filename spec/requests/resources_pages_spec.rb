require 'spec_helper'
require 'user_helper'

describe "ResourcesPages" do
	include_context "login user"

	shared_examples 'title and page_title' do |variable|
		it { should have_title(full_title(title)) }
		specify { expect(find('#page_title')).to have_content(title) }
	end

	RESOURCES = [Memory]

	RESOURCES.each do |resource|

		describe "index" do
			let(:title) { resource.model_name.human count: 2 }
			before {visit polymorphic_path(resource)}

			it_behaves_like "title and page_title"

			it { should have_link( I18n.t('fishing_memories.new_model', 
      model: resource.model_name.human), href: new_polymorphic_path(resource)) }
      
		end

		describe "create" do
			let(:title) { I18n.t('fishing_memories.new_model', model: resource.model_name.human) }
		  before {visit new_polymorphic_path(resource)}

		  it_behaves_like "title and page_title"
		end
	end
end

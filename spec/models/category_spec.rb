require 'spec_helper'
require 'category_helpers'

describe Category do
	let(:user) { FactoryGirl.create(:user) }
	before do
		@category = Category.create(name: "Категория", user_id: user.id)
	end

	subject { @category }

	it { should respond_to(:name) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	it { should respond_to(:type) }

	it { should be_valid }

	describe "validation" do

		describe "with blank name" do
			before {@category.name = ' '}
			it { should_not be_valid }
		end

	end

	describe "order" do
		before do
			Category.delete_all
		end

		let!(:c3) { FactoryGirl.create(:category, name: 'В категория', user: user) }
		let!(:c2) { FactoryGirl.create(:category, name: 'Б категория', user: user) }
		let!(:c1) { FactoryGirl.create(:category, name: 'А категория', user: user) }

		it "should have rights categories in right order" do
			expect(Category.all.to_a).to eq [c1, c2, c3]
		end
	end


	describe "typeable" do
		include_context "category helpers"

		CATEGORY_TYPES.each do |type|
			describe "for #{type} scope" do
				before do
					@sub_category = typeable_category_class(type).create(name: type, user_id: user.id)
				end
				specify { expect(Category.send(scope_name(type))).to include(@sub_category)}
			end

			describe "subclasses creation" do
				before do
					@sub_class_variable = Category.create(name: type, type: type, user_id: user.id)
				end
				specify { expect(@sub_class_variable).to be_kind_of typeable_category_class(type)}
			end

		end
	end
	
	describe PondCategory do
		before do
			@category = PondCategory.create(name: "Категория", user_id: user.id)
		end
		specify { expect(@category).to respond_to(:ponds) }

		its(:related_resources_plural_name) { should eq "ponds" }
		its(:related_resources_single_name) { should eq "pond" }

		describe "#related_resources" do
			let!(:pond) { FactoryGirl.create(:pond, user: user, category: @category) }
			its(:related_resources) {should include(pond)}

			specify { expect(@category.related_resources).to eq @category.ponds }
		end

	end

	describe TackleSetCategory do
		before do
			@category = TackleSetCategory.create(name: "Категория", user_id: user.id)
		end
		specify { expect(@category).to respond_to(:tackle_sets) }

		its(:related_resources_plural_name) { should eq "tackle_sets" }
		its(:related_resources_single_name) { should eq "tackle_set" }

		describe "#related_resources" do
			let!(:tackle_set) { FactoryGirl.create(:tackle_set, user: user, category: @category) }
			its(:related_resources) {should include(tackle_set)}

			specify { expect(@category.related_resources).to eq @category.tackle_sets }
		end
	end

	describe TackleCategory do
		before do
			@category = TackleCategory.create(name: "Категория", user_id: user.id)
		end
		specify { expect(@category).to respond_to(:tackles) }

		its(:related_resources_plural_name) { should eq "tackles" }
		its(:related_resources_single_name) { should eq "tackle" }

		describe "#related_resources" do
			let!(:tackle) { FactoryGirl.create(:tackle, user: user, category: @category) }
			its(:related_resources) {should include(tackle)}

			specify { expect(@category.related_resources).to eq @category.tackles }
		end
	end

end


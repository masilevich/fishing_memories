require 'spec_helper'
require 'category_helper'

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
		include_context "category helper"

		CATEGORY_TYPES.each do |type|
			describe "for #{type} scope" do
				before do
				  @sub_category = category_class(type).create(name: type, user_id: user.id)
				end
				specify { expect(Category.send(scope_name(type))).to include(@sub_category)}
			end

			describe "subclasses creation" do
				before do
					@sub_class_variable = Category.create(name: type, type: type, user_id: user.id)
				end
				specify { expect(@sub_class_variable).to be_kind_of category_class(type)}
			end

		end
	end
	
end
require 'spec_helper'
require "models/shared_examples/categorizable"
require "models/shared_examples/resource_with_name"

describe TackleSet do
	it_should_behave_like "resource with name"

	let(:user) { FactoryGirl.create(:user) }
	before { @tackle_set= user.tackle_sets.build(name: "Лайт") }

	subject { @tackle_set }

	it { should respond_to(:memories) }
	it { should respond_to(:tackles) }

	it_should_behave_like "categorizable"

	describe "#title" do
		context "without tackles" do
			its(:title) { should eq @tackle_set.name }
		end

		context "with tackles" do
			let!(:first_tackle) { FactoryGirl.create(:tackle, user: user, name: "Dexter") }
			let!(:second_tackle) { FactoryGirl.create(:tackle, user: user, name: "Vanquish") }
			before do
				@tackle_set.tackles << first_tackle
				@tackle_set.tackles << second_tackle
				@tackle_set.save
			end
			its(:title) { should eq "Лайт (Dexter + Vanquish)" }
		end
	end
end

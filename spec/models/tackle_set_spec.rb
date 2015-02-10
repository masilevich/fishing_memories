require 'spec_helper'

describe TackleSet do
	it_should_behave_like "resource with name"

	let(:user) { FactoryGirl.create(:user) }
	before { @tackle_set= user.tackle_sets.build(name: "Fishing tackle") }

	subject { @tackle_set }

	it { should respond_to(:memories) }
	it { should respond_to(:tackles) }

	it_should_behave_like "categorizable"

	describe "#title" do
		context "without tackles" do
			its(:title) { should eq @tackle_set.name }
		end

		context "with tackles" do
			let!(:tackles) { FactoryGirl.create_list(:tackle, 3, user: user) }
			before do
				tackles.sort_by!{|e| e.name}
				@tackle_set.tackles << tackles
				@tackle_set.save
			end
			its(:title) { should eq "#{@tackle_set.name} (#{tackles.first.name} + #{tackles.second.name} + #{tackles.third.name})" }
		end
	end
end

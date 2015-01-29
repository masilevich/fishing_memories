require 'spec_helper'

describe Tackle do
	it_should_behave_like "resource with name"

	let(:user) { FactoryGirl.create(:user) }
	before { @tackle= user.tackles.build(name: "Fishing tackle") }

	subject { @tackle }

	it { should respond_to(:memories) }
	it { should respond_to(:tackle_sets) }

	describe "#title" do
		its(:title) { should eq @tackle.name }
	end

	describe "#memories_with_tackle_sets_memories" do
	  let!(:in_tackle_tackle_set) { FactoryGirl.create(:tackle_set, user: user, tackles: [@tackle] ) }
	  let!(:other_tackle_set) { FactoryGirl.create(:tackle_set, user: user) }
	  let!(:memory_in_tackle) { FactoryGirl.create(:memory, user: user, tackles: [@tackle]) }
	  let!(:memory_in_tackle_set) { FactoryGirl.create(:memory, user: user, 
	  	                tackle_sets: [in_tackle_tackle_set]) }
	  let!(:other_memory) { FactoryGirl.create(:memory, user:user) }
	  let!(:memory_with_other_tackle_set) { FactoryGirl.create(:memory, 
	  	user: user, tackle_sets: [other_tackle_set]) }

	  describe "tackle memories" do
	    specify { expect(@tackle.memories_with_tackle_sets_memories).to include(memory_in_tackle) }
	  end

	  describe "tackle set memories" do
	    specify { expect(@tackle.memories_with_tackle_sets_memories).to include(memory_in_tackle_set) }
	  end

	  describe "other memories" do
	    specify { expect(@tackle.memories_with_tackle_sets_memories).to_not include(other_memory) }
	  end

	  describe "other tackle set memories" do
	    specify { expect(@tackle.memories_with_tackle_sets_memories).to_not include(memory_with_other_tackle_set) }
	  end
	end
end

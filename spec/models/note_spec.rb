require 'spec_helper'
require "models/shared_examples/resource_with_name"

describe Note do
	it_should_behave_like "resource with name"

	let(:user) { FactoryGirl.create(:user) }
	before { @note= user.notes.build(name: "note") }

	subject { @note }

	it { should respond_to(:text) }
	it { should respond_to(:tag_list) }

	describe "order" do
		before do
			Note.delete_all
		end

		let!(:first) { FactoryGirl.create(:note, user: user, 
		name: 'c', updated_at: Date.today) }
		let!(:second) { FactoryGirl.create(:note, user: user, 
		name: 'b', updated_at: 1.day.ago) }
		let!(:third) { FactoryGirl.create(:note, user: user, 
		name: 'a', updated_at: 2.day.ago) }

		it "should have rights notes in right order" do
			expect(Note.all.to_a).to eq [first, second, third]
		end
	end

	describe "#title" do
		its(:title) { should eq @note.name }
	end
end
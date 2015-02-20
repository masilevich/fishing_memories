require 'spec_helper'

describe Place do
  it_should_behave_like "resource with name"

	let(:user) { FactoryGirl.create(:user) }
	before { @place = user.places.build(name: "Мостик") }

	subject { @place }

	it { should respond_to(:memories) }
	it { should respond_to(:pond) }

	describe "#title" do
		context "without pond" do
			its(:title) { should eq @place.name }
		end

		context "with pond" do
			let!(:pond) { FactoryGirl.create(:pond, user: user, name: "Случь") }
			before do
				@place.pond = pond
				@place.save
			end
			its(:title) { should eq "Случь - Мостик"}
		end

	end

	describe ".without_pond" do
		describe "should include place without pond" do
			let!(:place) { FactoryGirl.create(:place) }
		  specify { expect(Place.without_pond).to include(place) }
		end

		describe "should not include place with category" do
			let!(:place_with_pond) { FactoryGirl.create(:place_with_pond) }
			specify { expect(Place.without_pond).to_not include(place_with_pond) }
		end
	end

	describe ".grouped_options_for_select" do
	  let!(:first_pond) { FactoryGirl.create(:pond, name: "a", user: user) }
	  let!(:second_pond) { FactoryGirl.create(:pond, name: "b", user: user) }
	  let!(:first_pond_places) { FactoryGirl.create_list(:place, 2, pond: first_pond, user: user).sort_by! {|u| u.name} }
	  let!(:second_pond_places) { FactoryGirl.create_list(:place, 2, pond: second_pond, user: user).sort_by! {|u| u.name} }
	  let!(:place_without_pond) { FactoryGirl.create(:place, user: user) }
	  specify do
	    expect(user.places.grouped_options_for_select(user.ponds)).to eq [
	    	[I18n.t('fishing_memories.all'), 
	    		[[place_without_pond.name, place_without_pond.id]]
	    	],
	    	[first_pond.name,
	    		[[first_pond_places.first.name, first_pond_places.first.id],
	    		[first_pond_places.second.name, first_pond_places.second.id]]
	    	],
	    	[second_pond.name,
	    		[[second_pond_places.first.name, second_pond_places.first.id],
	    		[second_pond_places.second.name, second_pond_places.second.id]]
	    	]
	    ]
	  end
	end 

end

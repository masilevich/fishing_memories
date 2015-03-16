require 'spec_helper'

describe Memory do
  let(:user) { FactoryGirl.create(:user) }
  before { @memory = user.memories.build(description: "Lorem ipsum", occured_at: Time.now) }

  subject { @memory  }

  it { should respond_to(:description) }
  it { should respond_to(:conclusion) }
  it { should respond_to(:occured_at) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:title) }
  it { should respond_to(:weather) }
  it { should respond_to(:tackles) }
  it { should respond_to(:tackle_sets) }
  it { should respond_to(:ponds) }
  it { should respond_to(:places) }
  it { should respond_to(:pond_state) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @memory.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank occured_at" do
    before { @memory.occured_at = "" }
    it { should_not be_valid }
  end

  describe "#title" do
    its(:title) { should eq "#{Memory.model_name.human} #{I18n.t('date.from')} #{@memory.occured_at}" }
  end

  describe "associations" do

    describe "tackles" do
      let!(:tackles) { FactoryGirl.create_list(:tackle, 2) }
      before do
        @memory = Memory.create(occured_at: Time.now, tackles: tackles)
      end
      it "should include tackles" do
        tackles.each do |tackle| 
          expect(@memory.tackles).to include(tackle) 
        end 
      end
    end

    describe "ponds" do
      let!(:ponds) { FactoryGirl.create_list(:pond, 2) }
      before do
        @memory = Memory.create(occured_at: Time.now, ponds: ponds)
      end
      it "should include ponds" do
        ponds.each do |pond| 
          expect(@memory.ponds).to include(pond) 
        end 
      end
    end

    describe "tackle sets" do
      let!(:tackle_sets) { FactoryGirl.create_list(:tackle_set, 2) }
      before do
        @memory = Memory.create(occured_at: Time.now, tackle_sets: tackle_sets)
      end
      it "should include tackle sets" do
        tackle_sets.each do |tackle_set| 
          expect(@memory.tackle_sets).to include(tackle_set) 
        end 
      end
    end

  end
end

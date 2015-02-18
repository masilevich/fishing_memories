require 'spec_helper'

describe "authorization" do

  describe "memories" do
    it_should_behave_like "resource with authorization pages" do
      let(:resource_class) { Memory }
    end
  end

  describe "tackles" do
    it_should_behave_like "resource with authorization pages" do
      let(:resource_class) { Tackle }
    end
  end

  describe "ponds" do
    it_should_behave_like "resource with authorization pages" do
      let(:resource_class) { Pond }
    end
  end

  describe "tackle sets" do
    it_should_behave_like "resource with authorization pages" do
      let(:resource_class) { TackleSet }
    end
  end

  describe "categories" do
    it_should_behave_like "resource with authorization pages" do
      let(:resource_class) { Category }
    end
  end

  describe "places" do
    it_should_behave_like "resource with authorization pages" do
      let(:resource_class) { Place }
    end
  end
  
end
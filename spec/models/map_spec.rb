require 'spec_helper'

describe Map do
	
  before do
    @map = Map.new()
  end

  subject { @map }

  it { should respond_to(:points) }

  it { should be_valid }
end

require 'spec_helper'

describe Point do

  before do
    @point = Point.new(name: "first point", description: "desc")
  end

  subject { @point }

  it { should respond_to(:map) }

  it { should be_valid }
end

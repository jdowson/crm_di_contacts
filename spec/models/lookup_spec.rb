require 'spec_helper'

describe Lookup do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :parent_id => 1,
      :description => "value for description",
      :status => "value for status",
      :type => "value for type"
    }
  end

  it "should create a new instance given valid attributes" do
    Lookup.create!(@valid_attributes)
  end
end

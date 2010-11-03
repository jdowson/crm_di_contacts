require 'spec_helper'

describe Lookup do

  before(:each) do
    @valid_attributes = {
      :name        => "account.type",
      :parent_id   => nil,
      :description => "Account Type",
      :status      => "Active",
      :lookup_type => "Standard"
    }
  end

  it "should create a new instance given valid attributes" do
    Lookup.create!(@valid_attributes)
  end

end

require 'spec_helper'

describe LookupItem do

  before(:each) do

    @lookup = Factory(:lookup)

    @valid_attributes = {
      :lookup_id         => 1,
      :sequence          => 1,
      :parent_id         => nil,
      :code              => "A0001",
      :language          => "EN-UK",
      :description       => "A0001 Description",
      :long_description  => "Long description for A0001",
      :html_color        => "lightblue",
      :item_type         => "Standard",
      :status            => "Active",
      :deleted_at        => nil
    }

  end

  
  it "should create a new instance given valid attributes" do
    LookupItem.create!(@valid_attributes)
  end

  
  describe "lookup association" do

    before(:each) do
      @item = @lookup.items.create(@valid_attributes)
    end

    it "should have a lookup attribute" do
      @item.should respond_to(:lookup)
    end

    it "should have the right associated lookup" do
      @item.lookup_id.should == @lookup.id
      @item.lookup.should == @lookup
    end

    it "should require nonblank code" do
      @lookup.items.build(:code => "  ").should_not be_valid
    end

    it "should reject long codes" do
      @lookup.items.build(:code => "a" * 51).should_not be_valid
    end
  
  end

end

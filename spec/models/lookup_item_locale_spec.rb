require 'spec_helper'

describe LookupItemLocale do

  before(:each) do

    @lookup_item = Factory(:lookup_item)

    @valid_attributes = {
      :lookup_item_id    => 1,
      :language          => "DE",
      :description       => "A0001 Description in German",
      :long_description  => "Long German description for A0001",
      :deleted_at        => nil    }

  end

  
  it "should create a new instance given valid attributes" do
    LookupItemLocale.create!(@valid_attributes)
  end

  
  describe "validations" do

    before(:each) do
      @item_locale = @lookup_item.locales.create(@valid_attributes)
    end

    it "should reject long long_descriptions" do
      @lookup_item.locales.build(:long_description => "a" * 256).should_not be_valid
    end
  
    it "should reject long descriptions" do
      @lookup_item.locales.build(:description => "a" * 256).should_not be_valid
    end
  
  end


  describe "lookup item association" do

    before(:each) do
      @item_locale = @lookup_item.locales.create(@valid_attributes)
    end

    it "should have an item attribute" do
      @item_locale.should respond_to(:lookup_item)
    end

    it "should have the right associated lookup item" do
      @item_locale.lookup_item_id.should == @lookup_item.id
      @item_locale.lookup_item.should == @lookup_item
    end

  end

end
 

require 'spec_helper'

describe Pivotal::Collection do
  
  before(:each) do
    @api = pivotal_api
  end
  
  it "should find a single item given an id" do
    @api.projects.find(1).should be_a(Pivotal::Project)
  end
  
  it "should find a collection of items giving a set of conditions" do
    @api.projects.find(:all).should be_a(Array)
    @api.projects.first.should be_a(Pivotal::Project)
  end
  
  it "should return the first item of a collection" do
    @api.projects.first.should be_a(Pivotal::Project)
  end

  it "should return items with correct ids" do
    @api.projects.find(1).id.should == "1"
  end

  it "should return items with correct resource URLs" do
    @api.projects.find(:all).each do |project|
      project.resource.url.split("/").last.should == project.id
    end
  end
  
end
#!/usr/bin/env rspec

require 'spec_helper'
require 'cache/exceptions'

describe Cache::Exception do
  it "should be a child of Exception" do
    subject.class.superclass.should == Exception
  end
end

describe Cache::ParameterException do
  it "should be a child of Cache::Exception" do
    subject.class.superclass.should == Cache::Exception
  end
end

describe Cache::EntryExpired do
  it "should be a child of Cache::Exception" do
    subject.class.superclass.should == Cache::Exception
  end
end

describe Cache::EntryMissing do
  it "should be a child of Cache::Exception" do
    subject.class.superclass.should == Cache::Exception
  end
end

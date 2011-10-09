#!/usr/bin/env rspec

require 'spec_helper'
require 'cache'

describe Cache do
  describe "object initialization" do
    it "should takes minimal parameters and creates a cache object" do
      # create a tempfile - but mainly to get the path
      t = tmpfile
      a = Cache.new(:file => t.path)
      a.should.class == Cache
      t.unlink
    end

    describe "options parameter" do
      describe ":file" do
        it "is mandatory" do
          pending "needs tests & implementation" 
        end
      end

      describe "that does not exist" do
        it "should fail with an error to avoid interface ambiguity" do
          pending "needs tests & implementation"
        end
      end
    end
  end

  describe "using the method" do
    let(:cache_file_obj) { tmpfile }
    let(:cache_file_path) { cache_file_obj.path }
    let(:cache_obj) { Cache.new(:file => cache_file_path) }

    after :each do
      # cleanup old cache files
      cache_file_obj.unlink
    end

    describe "store" do
      it "should accept key and data for storage and return nothing" do
        cache_obj.store("a", "b").should be_nil
      end
    end

    describe "retrieve" do
      it "should accept a key and return corresponding data" do
        cache_obj.store("a", "b")
        cache_obj.retrieve("a").should == "b"
      end
    end
  end
end

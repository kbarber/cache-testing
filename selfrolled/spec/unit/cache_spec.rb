#!/usr/bin/env rspec

require 'spec_helper'
require 'cache'

describe Cache do
  describe "object initialization" do
    let(:cache_file_obj) { tmpfile }
    let(:cache_file_path) { tmpfile.path }

    after :each do
      cache_file_obj.unlink
    end

    it "should takes minimal parameters and creates a cache object" do
      a = Cache.new(:file => cache_file_path)
      a.should.class == Cache
    end

    describe "options parameter" do
      describe ":file" do
        it "is mandatory and should raise exception if not provided" do
          expect { Cache.new() }.should raise_error(Cache::ParameterException, /^The :file option is a mandatory option during creation of a Cache object/)
        end

        it "should raise exception if path is not writeable" do
          pending "needs tests & implementation" 
        end
      end

      describe ":default_ttl" do
        it "is optional" do
          pending "needs tests & implementation" 
        end

        it "must accept a valid value for a ttl without transformation" do
          a = Cache.new(:file => cache_file_path, :default_ttl => 5)   
          a.cache_options[:default_ttl].should == 5
        end

        it "must throw a Cache::ParameterException when not a valid ttl" do
          pending "needs tests & implementation" 
        end
      end

      describe "that does not exist" do
        it "should raise exception to avoid interface ambiguity" do
          pending "needs implementation"
          expect { Cache.new(:file => cache_file_path, :invalid_parameter => nil) }.should raise_error(Cache::ParameterException)
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

      describe "options parameter" do
        describe ":ttl" do
          it "should accept a positive integer as a value" do
            pending("needs tests & implementation")
          end

          it "should use 0 as a default value" do
            pending("needs tests & implementation")
          end
        end
      end
    end

    describe "retrieve" do
      it "when passed a key that doesn't exist should raise Cache::EntryMissing exception" do
        key = "a"
        expect { cache_obj.retrieve(key) }.should raise_error(Cache::EntryMissing, /^The entry #{key} cannot be found in the internal cache data store/)
      end

      it "when passed just a key should return previously stored data" do
        cache_obj.store("a", "b")
        cache_obj.retrieve("a").should == "b"
      end

      it "should raise Cache::EntryExpired exception when entry expired" do
        cache_obj.stubs(:current_time).returns(100)
        cache_obj.store("a", "b", :ttl => 2, :time_updated => 1)
        expect { cache_obj.retrieve("a") }.should raise_error(Cache::EntryExpired, /^The entry .+ has expired/)
      end
    end

    describe "cache_options" do
      it "should return options passed during initialization" do
        options = [
          {
             :file => cache_file_path,
          },
          {
             :file => cache_file_path,
             :default_ttl => 0
          },
        ]
        options.each do |opt|
          a = Cache.new(opt)
          a.cache_options.should == opt
        end
      end
    end
  end
end

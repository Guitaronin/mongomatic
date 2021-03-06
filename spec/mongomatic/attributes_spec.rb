require 'spec_helper'

describe "Mongomatic Attributes" do
  subject { GameObject.new(:silver_count => 2, :gold_count => "2", :friends => ["Tariq", "Cosmin"], :yet_another => :abc) }
  describe "fetching list of attributes" do
    it "returns empty list when no attributes are defined" do
      Person.attributes.should == []
    end
    it "returns list of attributes as symbols when they are defined" do
      GameObject.attributes.count.should == 12
      GameObject.attributes.each { |a| a.should be_kind_of Symbol }
    end
  end
  describe "attribute methods" do
    it "defines a reader instance method for each attribute" do
      GameObject.attributes.each do |a|
        subject.should respond_to a
      end
    end
    it "defines a writer instance method for each attribute" do
      GameObject.attributes.each do |a|
        subject.should respond_to "#{a}=".to_sym
      end
    end
    specify "reader returns value for attribute" do
      subject.silver_count.should == subject['silver_count']
    end
    specify "writer updates value for attribute" do
      subject.silver_count = 0
      subject.silver_count.should == 0
    end
  end
  describe "type casting" do
    it "casts type on creation" do
      subject['gold_count'].should == 2
      subject.gold_count.should == 2
    end
    it "casts on update" do
      subject['gold_count'] = "3"
      subject.gold_count.should == 3
      subject.gold_count = 4.12
      subject['gold_count'].should == 4
    end
    describe "to string" do
      it "casts any object responding to #to_s" do
        mock = double("string-like")
        mock.stub(:to_s).and_return("abc")
        subject.name = mock
        subject['name'].should == "abc"
      end
    end
    describe "to float" do
      it "casts any object responding to #to_f" do
        mock = double("float-like")
        mock.stub(:to_f).and_return(1.23)
        subject.x_pos = mock
        subject['x_pos'].should == 1.23
      end
      it "raises CannotCastValue for objects not responding to #to_f" do
        mock = double("not-float-like")
        expect { subject['x_pos'] = mock }.to raise_exception Mongomatic::TypeConverters::CannotCastValue
      end
    end
    describe "to BSON::ObjectId" do
      it "casts valid ObjectId strings" do
        id = subject.insert!
        subject.item = id.to_s
        subject.item.should be_kind_of BSON::ObjectId        
      end
      it "raises CannotCastValue for invalid ObjectIds" do
        expect { subject.item = "123" }.to raise_exception Mongomatic::TypeConverters::CannotCastValue        
      end
    end
    describe "to boolean" do
      it "casts integer value 1 to TrueClass" do
        subject['alive'] = 1
        subject.alive.class.should == TrueClass
      end
      it "casts 't' to TrueClass" do
        subject['alive'] = "t"
        subject['alive'].class.should == TrueClass
      end
      it "casts 'true' to TrueClass" do
        subject.alive = "true"
        subject.alive.class.should == TrueClass
      end
      it "casts 'y' to TrueClass" do
        subject['alive'] = "y"
        subject['alive'].class.should == TrueClass
      end
      it "casts 'yes' to TrueClass" do
        subject['alive'] = "yes"
        subject.alive.class.should == TrueClass
      end
      it "casts integer value 0 to FalseClass" do
        subject.alive = 0
        subject.alive.class.should == FalseClass
      end
      it "casts 'f' to FalseClass" do
        subject.alive = "f"
        subject.alive.class.should == FalseClass
      end
      it "casts 'false' to FalseClass" do
        subject.alive = "false"
        subject.alive.class.should == FalseClass
      end
      it "casts 'n' to FalseClass" do
        subject.alive = "n"
        subject.alive.class.should == FalseClass
      end
      it "casts 'no' to FalseClass" do
        subject.alive = "no"
        subject.alive.class.should == FalseClass
      end
      it "raises CannotCastValue for any other value" do
        expect { subject.alive = "who_cares" }.to raise_exception Mongomatic::TypeConverters::CannotCastValue
      end
    end
    describe "to hash" do
      it "casts objects responding to #to_hash" do
        mock = double("some_hashlike_object")
        mock.stub(:to_hash).and_return({:some_data => 1})
        subject['other_data'] = mock
        subject['other_data'].should be_kind_of Mongomatic::MHash
        subject['other_data'][:some_data].should == 1
      end
      it "casts objects responding to #to_h" do
        mock = double("some_hashlike_object")
        mock.stub(:to_h).and_return({:some_data => 2})
        subject.other_data = mock
        subject.other_data.should be_kind_of Mongomatic::MHash
        subject['other_data.some_data'].should == 2
      end
      it "raises CannotCastValue for objets not responding to #to_hash or #to_h" do
        expect { subject.other_data = 1}.to raise_exception(Mongomatic::TypeConverters::CannotCastValue)
      end
    end
    describe "to symbol" do
      it "casts objects responding to #to_sym" do
        obj = double("symbol-like")
        obj.stub(:to_sym).and_return(:some_symbol)
        subject['some_flag'] = obj
        subject.some_flag.should == :some_symbol
      end
      it "raises CannotCastValue for objects not responding to #to_sym" do
        obj = double("not-symbol-like")
        expect { subject.some_flag = obj }.to raise_exception Mongomatic::TypeConverters::CannotCastValue
      end
    end
    describe "to regex" do
      it "casts to string then regex" do
        subject.rx = 1
        subject.rx.should =~ "123"
      end
    end
    describe "to array" do
      # Note: in 1.8 currently, all objects respond to #to_a. 
      # in 1.9 you may receive CannotCastValue errors on 
      # objects not respoding to #to_a
      it "casts objects responding to #to_a" do
        obj = double("array-like")
        obj.stub(:to_a).and_return([1, 2])
        subject.animals = obj
        subject.animals.should == [1, 2]
      end
    end
  end
  describe "type checking" do
    it "is silent on initialize when value has proper type" do
      expect { GameObject.new(:another_field => "Abc") }.to_not raise_exception
    end
    it "raises InvalidType on initialize when value is not proper type" do
      expect { GameObject.new(:another_field => 1) }.to raise_exception Mongomatic::InvalidType
    end
    it "is silent on set when value is proper type" do
      expect { GameObject.new.another_field = "Abc" }.to_not raise_exception
    end
    it "raises InvalidType on set when valid is not proper type" do
      expect { GameObject.new.another_field = 1 }.to raise_exception Mongomatic::InvalidType
    end
  end
  describe "required fields" do
    specify "document is valid if no required fields are nil" do
      subject.should be_valid
    end
    specify "document is invalid if any required field is nil" do
      subject.delete(:yet_another)
      subject.should_not be_valid
    end
  end
end

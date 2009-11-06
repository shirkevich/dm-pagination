
require File.dirname(__FILE__) + '/../spec_helper'

describe DataMapper::ArrayPagination do
  before(:each) { @array = 20.times.inject([]) {|array, n| array << n + 1 } }
  
  describe "#page" do
    describe "given the page" do
      it "return the appropriately sized collection" do
        @array.page(1).should == @array[0..5]
        @array.page(2).should == @array[6..11]
        @array.page(3).should == @array[12..17]
      end
    
      describe "number" do
        it "should default to the first page" do
          @array.page.pager.current_page.should == 1
        end
      end
      
      describe "nil" do
        it "should default to the first page" do
          @array.page(nil).pager.current_page.should == 1
        end
      end
      
      describe "number below 1" do
        it "should default to the first page" do
          @array.page(0).pager.current_page.should == 1
          @array.page(-1).pager.current_page.should == 1
        end
      end
      
      describe "string" do
        it "should be coerced to ints" do
          @array.page('5').pager.current_page.should == 5
          @array.page('5.0').pager.current_page.should == 5
          @array.page('-1').pager.current_page.should == 1
        end
        
        describe "which is not numeric" do
          it "should default to the first page" do
            @array.page('wahoo').pager.current_page.should == 1
          end
        end
      end
      
      describe "of an arbitrary object" do
        it "should raise an error unless responding to #to_i" do
          lambda { @array.page(true) }.should raise_error
        end
      end
    end

    describe "options hash" do
      it "should be accepted as first param" do
        @array.page(:page => 2).pager.current_page.should == 2
      end
      
      it "should be accepted as second param" do
        @array.page(3, :page => 2).pager.current_page.should == 3
      end
    end
    
    describe "option" do
      describe ":per_page" do
        it "should default to 6" do
          @array.page.length.should == 6
        end
        
        it "should be allow an alternate value" do
          @array.page(1, :per_page => 3).should == @array[0..2]
          @array.page(2, :per_page => 3).should == @array[3..5]
          @array.page(3, :per_page => 3).should == @array[6..8]
        end
        
        it "should allow numeric strings" do
          @array.page(1, :per_page => '3').should == @array[0..2]
          @array.page(2, :per_page => '3').should == @array[3..5]
          @array.page(3, :per_page => '3').should == @array[6..8]
          @array.page(3, :per_page => '3').pager.per_page.should == 3
        end
        
        it "should delete keys when an indifferent hash is passed" do
          @array.page(1, 'per_page' => '3').should == @array[0..2]
          @array.page(2, 'per_page' => '3').should == @array[3..5]
          @array.page(3, 'per_page' => '3').should == @array[6..8]
          @array.page(3, 'per_page' => '3').pager.per_page.should == 3
        end
      end
         
      describe ":page" do
        it "should raise an error unless responding to #to_i" do
          lambda { @array.page(:page => true) }.should raise_error
          lambda { @array.page('page' => true) }.should raise_error
        end
        
         it "should delete keys when an indifferent hash is passed" do
           @array.page(:page => '2', 'page' => '2').should == @array[6..11]
           @array.page(:page => '2', 'page' => '2').pager.current_page.should == 2
        end
      end
    end
  end
  
  describe "#pager" do
    describe "#total" do
      it "should be assigned when paging" do
        @array.page.length.should == 6
        @array.page.pager.total.should == 20
      end
    end
    
    describe "#per_page" do
      it "should be assigned when paging" do
        @array.page.pager.per_page.should == 6
      end
    end
    
    describe "#current_page" do
      it "should be assigned when paging" do
        @array.page.pager.current_page.should == 1
        @array.page(3).pager.current_page.should == 3
      end
    end
    
    describe "#total_pages" do
      it "should be assigned when paging" do
        @array.page.pager.total_pages.should == 4
        @array.page(:per_page => 3).pager.total_pages.should == 7
        @array.page(:per_page => 2).pager.total_pages.should == 10
      end
    end
  end
end

require File.dirname(__FILE__) + '/../../spec_helper'

describe 'Slicehost.reboot_slice' do
  describe 'success' do

    before(:each) do
      # flavor_id 1: 256 ram, image_id 3: Gentoo 2008.0
      @slice_id = Slicehost[:slices].create_slice(1, 3, 'fog_create_slice').body['id']
      wait_for { Slicehost[:slices].get_slice(@slice_id).body['status'] == 'active' }
    end

    after(:each) do
      wait_for { Slicehost[:slices].get_slice(@slice_id).body['status'] == 'active' }
      Slicehost[:slices].delete_slice(@slice_id)
    end

    it "should return proper attributes" do
      actual = Slicehost[:slices].reboot_slice(@slice_id).body
      actual['addresses'].should be_a(Array)
      # actual['backup-id'].should be_an(Integer)
      actual['bw-in'].should be_a(Float)
      actual['bw-out'].should be_a(Float)
      actual['flavor-id'].should be_an(Integer)
      actual['id'].should be_an(Integer)
      actual['image-id'].should be_an(Integer)
      actual['name'].should be_an(String)
      actual['progress'].should be_an(Integer)
      actual['status'].should be_an(String)
    end

  end
  describe 'failure' do

    it "should raise a Forbidden error if the server does not exist" do
      lambda {
        Slicehost[:slices].reboot_slice(0)
      }.should raise_error(Excon::Errors::Forbidden)
    end

  end
end

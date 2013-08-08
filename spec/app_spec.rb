require 'spec_helper'

describe 'The App' do
  it 'says hello' do
    get '/'
    last_response.should be_ok
    last_response.body.should == 'Hello World'
  end
end

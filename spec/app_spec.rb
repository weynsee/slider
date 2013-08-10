require 'spec_helper'

describe 'Slider' do
  let(:path) { '/hello/world' }

  it 'redirects to shortened url' do
    get path
    last_response.should be_redirect
    slide = Slide.first(path: path)
    expect(slide).not_to be_nil
    expect(last_response.location).to include(slide.permalink)
  end

  it 'does not create a new record when the path already exists' do
    Slide.create(path: path)
    total_records = Slide.count
    get path
    expect(Slide.count).to eq(total_records)
  end

  it 'renders the appropriate slide' do
    slide = Slide.create(path: path)
    get "/p/#{slide.permalink}"
    expect(last_response).to be_ok
  end

  after { Slide.destroy }
end

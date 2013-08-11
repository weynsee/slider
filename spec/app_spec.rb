require 'spec_helper'

describe 'Slider' do
  let(:path) { '/hello/world' }

  describe 'GET *' do
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

    describe 'empty path' do
      it 'returns 404 for /' do
        get '/'
        last_response.should be_not_found
      end

      it 'returns 404 for root' do
        get ''
        last_response.should be_not_found
      end
    end
  end

  describe 'GET /p/:permalink' do
    let(:slide) { Slide.create(path: path) }
    subject { get "/p/#{slide.permalink}" }

    it { should be_ok }
    its(:body) { should include('<title>hello world</title>') }

    describe 'permalink does not exist' do
      subject { get '/p/404' }
      it { should be_not_found }
    end

    describe 'permalink is invalid' do
      subject { get '/p/four-oh-four' }
      it { should be_not_found }
    end
  end

  after { Slide.destroy }
end

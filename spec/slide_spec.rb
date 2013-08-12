require 'spec_helper'

describe 'Slide' do
  let(:slide) { Slide.create(path: '/hello/world') }

  describe '#permalink' do
    it "returns a permalink corresponding to the bijective encoding of the instance's id" do
      expect(slide.permalink).to eq(Bijective.encode(slide.id))
    end
  end

  describe '.find_by_permalink' do
    it 'finds a slide by its permalink' do
      returned_slide = Slide.find_by_permalink(slide.permalink)
      expect(returned_slide).to eq(slide)
    end

    it 'returns nil for invalid permalink' do
      expect(Slide.find_by_permalink('w-t')).to be_nil
    end
  end

  describe '#panels' do
    it 'returns an array of panels to be displayed' do
      expect(slide.panels).to eq(%w{hello world})
    end
  end

  after { Slide.destroy }
end

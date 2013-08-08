require './lib/bijective'

describe Bijective do
  it 'shortens a number then decode the resulting string to the same number' do
    str = Bijective.encode(42)
    expect(Bijective.decode(str)).to(eq(42))
  end
end

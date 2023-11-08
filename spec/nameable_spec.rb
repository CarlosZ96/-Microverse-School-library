require_relative '../nameable'

describe Nameable do
  it 'throws NotImplementedError when calling #correct_name' do
    nameable = Nameable.new
    expect { nameable.correct_name }.to raise_error(NotImplementedError)
  end
end

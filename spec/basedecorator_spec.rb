require_relative '../nameable'
require_relative '../basedecorator'


describe BaseDecorator do
  let(:nameable) { instance_double('Nameable', correct_name: 'john doe') }
  subject { BaseDecorator.new(nameable) }

  describe '#correct_name' do
    it 'returns the name from the nameable' do
      expect(subject.correct_name).to eq('john doe')
    end
  end
end

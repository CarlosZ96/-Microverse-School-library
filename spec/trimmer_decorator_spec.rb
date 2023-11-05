require_relative '../basedecorator' # Igual que arriba, asegúrate de requerir first basedecorator antes de trimmerdecorator.
require_relative '../trimmerdecorator'

describe TrimmerDecorator do
  let(:nameable) { instance_double('Nameable', correct_name: 'john doe smith') }
  subject { TrimmerDecorator.new(nameable) }

  describe '#correct_name' do
    it 'trims the name from the nameable to 10 characters' do
      expect(subject.correct_name).to eq('john doe s')
    end
  end
end

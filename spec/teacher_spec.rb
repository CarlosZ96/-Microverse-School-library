require_relative '../teacher'

describe Teacher do
  let(:teacher) { Teacher.new(40, 'Jane Doe', 'Mathematics') }

  describe '#new' do
    it 'creates a new teacher with a name, age, and specialization' do
      expect(teacher).to have_attributes(name: 'Jane Doe', age: 40, specialization: 'Mathematics')
    end
  end

  describe '#can_use_services?' do
    it 'returns true' do
      expect(teacher.can_use_services?).to be true
    end
  end
  describe '#to_hash' do
    it 'returns a hash with teacher details and specialization' do
      hash = teacher.to_hash
      expect(hash).to be_a(Hash)
      expect(hash[:id]).to eq(teacher.id)
      expect(hash[:name]).to eq('Jane Doe')
      expect(hash[:age]).to eq(40)
      expect(hash[:specialization]).to eq('Mathematics')
      expect(hash[:type]).to eq('Teacher')
    end
  end
end

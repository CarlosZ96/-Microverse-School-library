require_relative '../student'
require_relative '../classroom'

describe Student do
  let(:classroom) { Classroom.new('Programming 101') }
  let(:student) { Student.new(18, 'John Doe', 'Programming 101') }

  describe '#new' do
    it 'creates a new student with a name, age, and classroom label' do
      expect(student).to have_attributes(name: 'John Doe', age: 18)
      expect(student.classroom.label).to eq 'Programming 101'
    end
  end

  describe '#play_hooky' do
    it 'returns the string "¯\(ツ)/¯"' do
      expect(student.play_hooky).to eq '¯\(ツ)/¯'
    end
  end

  describe '#classroom' do
    it 'adds the student to the classroom' do
      expect(student.classroom.students).to include(student)
    end
  end
  describe '#to_hash' do
    it 'returns a hash with student details and classroom label' do
      hash = student.to_hash
      expect(hash).to be_a(Hash)
      expect(hash[:id]).to eq(student.id)
      expect(hash[:name]).to eq('John Doe')
      expect(hash[:age]).to eq(18)
      expect(hash[:classroom]).to eq('Programming 101')
      expect(hash[:type]).to eq('Student')
    end
  end
end

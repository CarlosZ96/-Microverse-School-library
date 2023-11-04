require_relative '../classroom'
require_relative '../student'
describe Classroom do
  let(:classroom) { Classroom.new('Programming 101') }
  let(:student) { Student.new(18, 'John Doe', 'Programming 101') }
  describe '#new' do
    it 'creates a new Classroom with a label' do
      expect(classroom.label).to eq 'Programming 101'
    end
  end
  describe '#add_student' do
    it 'adds a student to the classroom' do
      classroom.add_student(student)
      expect(classroom.students).to include(student)
    end
    it 'does not add the same student twice' do
      classroom.add_student(student)
      classroom.add_student(student)
      expect(classroom.students.size).to eq 1
    end
  end
end
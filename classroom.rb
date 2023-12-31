require_relative 'student'
class Classroom
  attr_accessor :label
  attr_reader :students

  def initialize(label)
    @label = label
    @students = []
  end

  def add_student(student)
    @students << student unless @students.include?(student)
    student.classroom = self unless student.classroom == self
  end

  def to_hash
    {
      label: @label,
      students: @students.map(&:id)
    }
  end
end

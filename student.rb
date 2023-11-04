require_relative 'person'
require_relative 'classroom'
class Student < Person
  attr_reader :classroom
  def initialize(age, name, classroom_label, parent_permission: true, id: nil)
    super(age, name, parent_permission: parent_permission, id: id)
    @classroom = Classroom.new(classroom_label)
    classroom.add_student(self)
  end
  def play_hooky
    '¯\(ツ)/¯'
  end
  def classroom=(classroom)
    @classroom = classroom
    classroom.add_student(self) unless classroom.students.include?(self)
  end
  def to_hash
    super.merge({
      classroom: @classroom.label,
      type: 'Student'
    })
  end
end
require_relative 'main'

class Student < Person
  def initialize(age, id, classroom, name: 'Unknown', parent_permission: true)
    super(age, id, name, parent_permission)
    @classroom = classroom
  end

  def play_hooky
    '¯\(ツ)/¯'
  end
end

require_relative 'person'
class Teacher < Person
  attr_reader :specialization
  def initialize(age, name, specialization, parent_permission: true, id: nil)
    super(age, name, parent_permission: parent_permission, id: id)
    @specialization = specialization
  end
  def can_use_services?
    true
  end
  def to_hash
    super.merge({
      specialization: @specialization,
      type: 'Teacher'
    })
  end
end

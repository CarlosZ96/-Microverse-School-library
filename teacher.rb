require_relative 'main'

class Teacher
  def initialize(age, id, specialization, name: 'Unknown', parent_permission: true)
    super(age, id, name, parent_permission)
    @specialization = specialization
  end

  def can_use_services?
    true
  end
end

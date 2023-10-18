# frozen_string_literal: true

# Create class Person
class Person
  attr_accessor :name
  attr_reader :age, :id

  attr_writer age

  def initialize(age, id, name = 'Unknown', parent_permission = 'true')
    @id = id
    @name = name
    @age = age
    @parent_permission = parent_permission
  end

  private

  def of_age?
    @age > 18
  end
end

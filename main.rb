class Nameable
  def correct_name
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class Person < Nameable
  attr_accessor :name, :age
  attr_reader :id

  def initialize(age, id, name: 'Unknown', parent_permission: true)
    super()
    @name = name
    @age = age
    @id = id
    @parent_permission = parent_permission
  end

  def can_use_services?
    @age >= 18 || @parent_permission
  end

  def correct_name
    @name
  end

  private

  def of_age?
    @age < 18
  end
end

class BaseDecorator < Nameable
  def initialize(nameable)
    super()
    @nameable = nameable
  end

  def correct_name
    @nameable.correct_name
  end
end

class CapitalizeDecorator < BaseDecorator
  def correct_name
    original_name = @nameable.correct_name
    original_name.capitalize
  end
end

class TrimmerDecorator < BaseDecorator
  def correct_name
    original_name = @nameable.correct_name
    if original_name.length > 10
      original_name[0, 10]
    else
      original_name
    end
  end
end

person = Person.new(22, 1, name: 'maximilianus')
person.correct_name
capitalized_person = CapitalizeDecorator.new(person)
puts capitalized_person.correct_name
capitalized_trimmed_person = TrimmerDecorator.new(capitalized_person)
puts capitalized_trimmed_person.correct_name

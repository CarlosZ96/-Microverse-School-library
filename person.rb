require_relative 'rental'
class Person
  attr_reader :id, :name, :age, :rentals

  def initialize(age, name = 'Unknown', parent_permission: true, id: nil)
    @id = id || rand(1..1000)
    @name = name
    @age = age
    @parent_permission = parent_permission
    @rentals = []
  end

  def can_use_services?
    of_age? || @parent_permission
  end

  def add_rental(date, book)
    Rental.new(date, book, self)
  end

  def to_hash
    {
      id: @id,
      name: @name,
      age: @age,
      parent_permission: @parent_permission
    }
  end

  private

  def of_age?
    @age >= 18
  end
end

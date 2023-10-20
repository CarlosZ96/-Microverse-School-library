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

class Student
  attr_accessor :name
  attr_reader :classroom

  def initialize(name)
    @name = name
    @classroom = nil
  end

  def classroom(classroom)
    @classroom = classroom
    classroom.students.push(self) unless classroom.students.include?(self)
  end
end

class Classroom
  attr_accessor :label
  attr_reader :students

  def initialize(label)
    @label = label
    @students = []
  end

  def add_student(student)
    @students << student
    student.classroom = self
  end
end

class Book
  attr_accessor :title, :author
  attr_reader :rentals

  def initialize(title, author)
    @title = title
    @author = author
    @rentals = [] # Initialize the rentals array
  end
end

class Rental
  attr_accessor :date
  attr_reader :book, :person

  def initialize(date, book, person)
    @date = date
    @book = book
    @person = person
    book.rentals << self
    person.rentals << self
  end
end

classroom = Classroom.new('Room A')

student1 = Student.new('Alice')
student2 = Student.new('Bob')

classroom.add_student(student1)
classroom.add_student(student2)

puts "Students in #{classroom.label}: #{classroom.students.map(&:name).join(', ')}"

book1 = Book.new('Book 1', 'Author 1')
book2 = Book.new('Book 2', 'Author 2')
person1 = Student.new('Person 1')
person2 = Student.new('Person 2')
rental1 = Rental.new('2023-10-19', book1, person1)
rental2 = Rental.new('2023-10-20', book2, person2)

puts "#{person1.name} rented '#{book1.title}' on #{rental1.date}."
puts "#{person2.name} rented '#{book2.title}' on #{rental2.date}."

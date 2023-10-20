class Nameable
  def correct_name
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class Person < Nameable
  attr_reader :id
  attr_accessor :name, :age, :rentals

  def initialize(age:, name: 'Unknown', parent_permission: true)
    super()
    @id = nil
    @name = name
    @age = age
    @parent_permission = parent_permission
    @rentals = []
  end

  def can_use_services?
    of_age? || @parent_permission
  end

  def correct_name
    @name
  end

  def add_rental(book, date)
    Rental.new(date, book, self)
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

person = Person.new(age: 22, name: 'maximilianus', parent_permission: true)
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

  def classroom=(classroom)
    @classroom = classroom
    classroom.students.push(self) unless classroom.students.include?(self)
  end
end

class Classroom
  attr_accessor :label, :students

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
  attr_accessor :title, :author, :rentals

  def initialize(title, author)
    @title = title
    @author = author
    @rentals = []
  end

  def add_rental(person, date)
    @rentals << Rental.new(date, self, person)
  end
end

class Rental
  attr_accessor :date, :book, :person

  def initialize(date, book, person)
    @date = date
    @book = book
    @person = person
  end
end

classroom = Classroom.new('Room A')

student1 = Student.new('Alice')
student2 = Student.new('Bob')

classroom.add_student(student1)
classroom.add_student(student2)

puts "Students in #{classroom.label}: #{classroom.students.map(&:name).join(', ')}"

book1 = Book.new('100 años de soledad', 'Gabriel Garcia Marquez')
person1 = Person.new(age: 30, name: 'Carlos')

rental1 = Rental.new('2023-10-19', book1, person1)

puts "#{person1.name} rented '#{book1.title}' on #{rental1.date}."

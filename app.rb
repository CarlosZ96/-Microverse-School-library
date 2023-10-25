require_relative 'main'

class Nameable
  def correct_name
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class Person < Nameable
  attr_reader :id
  attr_accessor :name, :age, :rentals

  def initialize(age, name = 'Unknown', parent_permission: true)
    super()
    @id = rand(1..1000)
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

  def add_rentals(book, date)
    @rentals << Rental.new(date, book, self)
  end

  private

  def of_age?
    @age >= 18
  end
end

class BaseDecorator < Nameable
  attr_accessor :nameable

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
    @nameable.correct_name[0..9]
  end
end

class Student < Person
  attr_reader :classroom

  def initialize(age, name, classroom, parent_permission: true)
    super(age, name, parent_permission: parent_permission)
    @classroom = classroom
  end

  def play_hooky
    '¯(ツ)/¯'
  end

  def classroom=(classroom)
    @classroom = classroom
    classroom.students.push(self) unless classroom.students include?(self)
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

class Teacher < Person
  def initialize(age, name, specialization, parent_permission: true)
    super(age, name, parent_permission: parent_permission)
    @specialization = specialization
  end

  def can_use_services?
    true
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

    book.rentals << self
    person.rentals << self
  end
end

class App
  attr_accessor :books, :people, :rentals

  def initialize
    @books = []
    @people = []
    @rentals = []
  end

  def create_book
    print 'Title: '
    book_title = gets.chomp
    print 'Author: '
    book_author = gets.chomp
    new_book = Book.new(book_title, book_author)
    @books << new_book
    puts 'Book created successfully'
  end

  def list_all_books
    @books.each { |book| puts "Title: #{book.title}, Author: #{book.author}" }
  end

  def create_person
    puts 'Do you want to create a student (1) or a teacher (2)? [Input the number]: '
    person_class = gets.chomp
    result_arr = getting_name_age
    if person_class == '1'
      print 'Classroom: '
      student_classroom = gets.chomp
      print 'Has parent permission? [Y/N]: '
      parent_permission = gets.chomp.downcase
      parent_permission = parent_permission == 'y'
      new_student = Student.new(result_arr[0], result_arr[1], student_classroom, parent_permission: parent_permission)
      @people << new_student
    else
      print 'Specialization: '
      teacher_specialization = gets.chomp
      new_teacher = Teacher.new(result_arr[0], result_arr[1], teacher_specialization)
      @people << new_teacher
    end
    puts 'Person created successfully'
  end

  def getting_name_age
    common_arr = []
    print 'Age: '
    person_age = gets.chomp.to_i
    print 'Name: '
    person_name = gets.chomp
    common_arr << person_age
    common_arr << person_name
  end

  def list_all_people
    @people.each do |person_item|
      puts "[#{person_item.class}] Name: #{person_item.name}, ID: #{person_item.id}, Age: #{person_item.age}"
    end
  end

  def create_rental
    puts 'Select a book from the following list by number'
    @books.each_with_index { |book, index| puts "#{index}) Title: \"#{book.title}\", Author: #{book.author}" }
    book_index = gets.chomp.to_i
    puts 'Select a person from the following list by number (not id)'
    @people.each_with_index do |person_item, index|
      puts "#{index}) [#{person_item.class}] Name: #{person_item.name}, ID: #{person_item.id}, Age: #{person_item.age}"
    end
    person_index = gets.chomp.to_i
    print 'Date: '
    rental_date = gets.chomp
    @rentals << Rental.new(rental_date, @books[book_index], @people[person_index])
    puts 'Rental created successfully'
  end

  def list_person_rental
    print 'ID of person: '
    person_id = gets.chomp.to_i
    rentals_result = @rentals.select { |rental_item| rental_item.person.id == person_id }
    puts 'Rentals:'
    rentals_result.each do |rental_result|
      puts "Date: #{rental_result.date}, Book \"#{rental_result.book.title}\" by #{rental_result.book.author}"
    end
  end
end

def present_options
  puts "\nPlease choose an option by entering a number:"
  puts '1 - List all books'
  puts '2 - List all people'
  puts '3 - Create a person'
  puts '4 - Create a book'
  puts '5 - Create a rental'
  puts '6 - List all rentals for a given person id'
  puts '7 - Exit'
  gets.chomp.to_i
end

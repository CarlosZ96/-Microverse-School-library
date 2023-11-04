require 'json'
require_relative 'book'
require_relative 'person'
require_relative 'rental'
require_relative 'student'
require_relative 'teacher'
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

  def save_books
    File.write('books.json', JSON.pretty_generate(@books.map(&:to_hash)))
  end

  def save_people
    File.write('people.json', JSON.pretty_generate(@people.map(&:to_hash)))
  end

  def save_rentals
    File.write('rentals.json', JSON.pretty_generate(@rentals.map(&:to_hash)))
  end

  def load_books
    return unless File.exist?('books.json')

    JSON.parse(File.read('books.json')).each do |book_data|
      @books << Book.new(book_data['title'], book_data['author'])
    end
  end

  def load_people
    return unless File.exist?('people.json')

    JSON.parse(File.read('people.json')).each do |person_data|
      @people << if person_data['classroom']
                   Student.new(person_data['age'], person_data['name'], person_data['classroom'],
                               parent_permission: person_data['parent_permission'])
                 else
                   Teacher.new(person_data['age'], person_data['name'], person_data['specialization'])
                 end
    end
  end

  def load_rentals
    return unless File.exist?('rentals.json')

    JSON.parse(File.read('rentals.json')).each do |rental_data|
      book = @books.find { |b| b.title == rental_data['book']['title'] }
      person = @people.find { |p| p.id == rental_data['person']['id'] }
      @rentals << Rental.new(rental_data['date'], book, person) if book && person
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

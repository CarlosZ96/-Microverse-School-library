require_relative 'main'
require_relative 'teacher'

def list_books(books, _people, _rentals)
  books.each { |book| puts "Title: #{book.title}, Author: #{book.author}" }
end

def list_people(_books, people, _rentals)
  people.each do |person_item|
    puts "[#{person_item.class}] Name: #{person_item.name}, ID: #{person_item.id}, Age: #{person_item.age}"
  end
end

def create_person(_books, people, _rentals)
  puts 'Do you want to create a student (1) or a teacher (2)? [Input the number]: '
  person_class = gets.chomp

  if person_class == '1'
    create_student(people)
  else
    create_teacher(people)
  end

  puts 'Person created successfully'
end

def create_student(people)
  print 'Name: '
  student_name = gets.chomp
  print 'Age: '
  student_age = gets.chomp.to_i
  print 'Classroom: '
  student_classroom = gets.chomp
  print 'Has parent permission? [Y/N]: '
  parent_permission = gets.chomp.downcase
  parent_permission = parent_permission == 'y'

  new_student = Student.new(age: student_age, name: student_name, classroom: student_classroom,
                            parent_permission: parent_permission)
  people << new_student
end

def create_teacher(people)
  print 'Name: '
  teacher_name = gets.chomp
  print 'Age: '
  teacher_age = gets.chomp.to_i
  print 'Specialization: '
  teacher_specialization = gets.chomp

  new_teacher = Teacher.new(name: teacher_name, age: teacher_age, specialization: teacher_specialization)
  people << new_teacher
end

def getting_name_age
  common_arr = []
  print 'Age: '
  person_age = gets.chomp.to_i
  print 'Name: '
  person_name = gets.chomp
  common_arr << person_age
  common_arr << person_name
  common_arr
end

def create_book(books, _people, _rentals)
  print 'Title: '
  book_title = gets.chomp
  print 'Author: '
  book_author = gets.chomp
  new_book = Book.new(book_title, book_author)
  books << new_book
  puts 'Book created successfully'
end

def create_rental(rentals, people, books)
  puts 'Select a book from the following list by number'
  books.each_with_index do |book, index|
    puts "#{index}) Title: \"#{book.title}\", Author: #{book.author}"
  end
  book_index = gets.chomp.to_i
  puts 'Select a person from the following list by number (not id)'
  people.each_with_index do |person_item, index|
    puts "#{index}) [#{person_item.class}] Name: #{person_item.name}, ID: #{person_item.id}, Age: #{person_item.age}"
  end
  person_index = gets.chomp.to_i

  print 'Date: '
  rental_date = gets.chomp
  rentals << Rental.new(rental_date, books[book_index], people[person_index])
  puts 'Rental created successfully'
end

def list_rentals_for_person(rentals, _people, _books)
  people_with_rentals = rentals.map(&:person).uniq
  people_with_rentals.each do |person|
    puts "[Person ID: #{person.id}, Name: #{person.name}] Rentals:"
    person_rentals = rentals.select { |rental| rental.person == person }
    if person_rentals.empty?
      puts 'No rentals found for this person.'
    else
      person_rentals.each do |rental|
        puts "  Date: #{rental.date}, Book Title: #{rental.book.title}, Author: #{rental.book.author}"
      end
    end
  end
end

def main
  books = []
  people = []
  rentals = []
  loop do
    display_menu
    choice = gets.chomp.to_i
    process_choice(choice, books, people, rentals)
    break if choice == 7
  end
  puts 'Exiting the application.'
end

def process_choice(choice, books, people, rentals)
  menu_actions = {
    1 => method(:list_books),
    2 => method(:list_people),
    3 => method(:create_person),
    4 => method(:create_book),
    5 => method(:create_rental),
    6 => method(:list_rentals_for_person)
  }

  if menu_actions.key?(choice)
    menu_actions[choice].call(books, people, rentals)
  elsif choice == 7
    nil
  else
    puts 'Invalid choice. Please select a valid option.'
  end
end

def display_menu
  puts 'Choose an option:'
  puts '1. List all books'
  puts '2. List all people'
  puts '3. Create a person'
  puts '4. Create a book'
  puts '5. Create a rental'
  puts '6. List rentals for a person'
  puts '7. Quit'
end

main

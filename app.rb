require_relative 'main'

def list_books(books)
  books.each { |book| puts "Title: #{book.title}, Author: #{book.author}" }
end

def list_people(people)
  # Implement the code to list all people
end

def create_person(people)
  # Implement the code to create a person (teacher or student)
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
  # Implement the code to create a rental
end

def list_rentals_for_person(rentals, person_id)
  # Implement the code to list all rentals for a given person ID
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

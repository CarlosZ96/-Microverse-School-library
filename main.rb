require_relative 'app'
def start_method(app, option)
  case option
  when 1
    app.list_all_books
  when 2
    app.list_all_people
  when 3
    app.create_person
  when 4
    app.create_book
  when 5
    app.create_rental
  when 6
    app.list_person_rental
  else
    puts "Option not recognized."
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
def main
  app = App.new
  app.load_books
  app.load_people
  app.load_rentals
  puts 'Welcome to School Library App!'
  loop do
    option = present_options
    break if option == 7
    start_method(app, option)
  end
  app.save_books
  app.save_people
  app.save_rentals
end
main
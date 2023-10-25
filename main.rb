require_relative 'app'

def start_method(app, user_option)
  methods_list = {
    1 => :list_all_books,
    2 => :list_all_people,
    3 => :create_person,
    4 => :create_book,
    5 => :create_rental,
    6 => :list_person_rental,
    7 => :exit
  }
  app.send(methods_list[user_option])
end

def main
  app = App.new
  puts 'Welcome to School Library App!'
  loop do
    option = present_options
    if option == 7
      puts 'Thank you for using this app!'
      break
    end
    start_method(app, option)
  end
end

main

require_relative 'main'

# Define una clase base llamada 'Nameable' con un método 'correct_name' que genera una excepción si no se implementa en las clases derivadas.
class Nameable
  def correct_name
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Define una clase 'Person' que hereda de 'Nameable' y agrega propiedades y métodos específicos para una persona.
class Person < Nameable
  attr_reader :id
  attr_accessor :name, :age, :rentals

  # El constructor de la clase inicializa las propiedades de la persona.
  def initialize(age, name = 'Unknown', parent_permission: true)
    super() # Llama al constructor de la clase base.
    @id = rand(1..1000)
    @name = name
    @age = age
    @parent_permission = parent_permission
    @rentals = []
  end

  # Verifica si la persona puede usar servicios basados en su edad y permiso de los padres.
  def can_use_services?
    of_age? || @parent_permission
  end

  # Implementa el método 'correct_name' para devolver el nombre de la persona.
  def correct_name
    @name
  end

  # Agrega un libro a la lista de alquileres de la persona.
  def add_rentals(book, date)
    @rentals << Rental.new(date, book, self)
  end

  private

  # Comprueba si la persona es mayor de edad.
  def of_age?
    @age >= 18
  end
end

# Define una clase abstracta 'BaseDecorator' que hereda de 'Nameable' y agrega una propiedad para decorar objetos 'Nameable'.
class BaseDecorator < Nameable
  attr_accessor :nameable

  # El constructor toma un objeto 'Nameable' y lo almacena.
  def initialize(nameable)
    super()
    @nameable = nameable
  end

  # Implementa el método 'correct_name' para obtener el nombre correcto del objeto decorado.
  def correct_name
    @nameable.correct_name
  end
end

# Define una clase 'CapitalizeDecorator' que hereda de 'BaseDecorator' y capitaliza el nombre del objeto decorado.
class CapitalizeDecorator < BaseDecorator
  def correct_name
    original_name = @nameable.correct_name
    original_name.capitalize
  end
end

# Define una clase 'TrimmerDecorator' que hereda de 'BaseDecorator' y limita el nombre del objeto decorado a 10 caracteres.
class TrimmerDecorator < BaseDecorator
  def correct_name
    @nameable.correct_name[0..9]
  end
end

# Define una clase 'Student' que hereda de 'Person' y agrega una propiedad de 'classroom' y un método 'play_hooky'.
class Student < Person
  attr_reader :classroom

  # El constructor agrega la propiedad 'classroom' y permite establecer el permiso de los padres.
  def initialize(age, name, classroom, parent_permission: true)
    super(age, name, parent_permission: parent_permission)
    @classroom = classroom
  end

  # El método 'play_hooky' devuelve un emoticono.
  def play_hooky
    '¯(ツ)/¯'
  end

  # Permite asignar un aula a un estudiante y agrega al estudiante a la lista de estudiantes del aula.
  def classroom=(classroom)
    @classroom = classroom
    classroom.students.push(self) unless classroom.students.include?(self)
  end
end

# Define una clase 'Classroom' que representa un aula y almacena una lista de estudiantes.
class Classroom
  attr_accessor :label
  attr_reader :students

  # El constructor inicializa la etiqueta del aula y la lista de estudiantes.
  def initialize(label)
    @label = label
    @students = []
  end

  # Agrega un estudiante a la lista de estudiantes del aula y asigna el aula al estudiante.
  def add_student(student)
    @students << student
    student.classroom = self
  end
end

# Define una clase 'Teacher' que hereda de 'Person' y agrega una propiedad de 'specialization'.
class Teacher < Person
  def initialize(age, name, specialization, parent_permission: true)
    super(age, name, parent_permission: parent_permission)
    @specialization = specialization
  end

  # Sobrescribe el método 'can_use_services' para que los profesores siempre puedan usar los servicios.
  def can_use_services?
    true
  end
end

# Define una clase 'Book' que representa un libro y almacena información sobre el libro y sus alquileres.
class Book
  attr_accessor :title, :author, :rentals

  # El constructor inicializa el título y el autor del libro, así como la lista de alquileres.
  def initialize(title, author)
    @title = title
    @author = author
    @rentals = []
  end

  # Agrega un alquiler de este libro a la lista de alquileres del libro y de la persona.
  def add_rental(person, date)
    @rentals << Rental.new(date, self, person)
  end
end

# Define una clase 'Rental' que representa un alquiler de un libro y almacena información sobre la fecha, el libro y la persona involucrados.
class Rental
  attr_accessor :date, :book, :person

  # El constructor inicializa la fecha, el libro y la persona del alquiler y agrega el alquiler a las listas correspondientes.
  def initialize(date, book, person)
    @date = date
    @book = book
    @person = person

    book.rentals << self
    person.rentals << self
  end
end

# Define una clase 'App' que actúa como una aplicación para gestionar libros, personas y alquileres.
class App
  attr_accessor :books, :people, :rentals

  # El constructor inicializa listas vacías para libros, personas y alquileres.
  def initialize
    @books = []
    @people = []
    @rentals = []
  end

  # Permite al usuario crear un nuevo libro.
  def create_book
    print 'Title: '
    book_title = gets.chomp
    print 'Author: '
    book_author = gets.chomp
    new_book = Book.new(book_title, book_author)
    @books << new_book
    puts 'Book created successfully'
  end

  # Lista todos los libros disponibles en la aplicación.
  def list_all_books
    @books.each { |book| puts "Title: #{book.title}, Author: #{book.author}" }
  end

  # Permite al usuario crear una nueva persona (ya sea estudiante o profesor).
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

  # Obtiene la edad y el nombre de una persona del usuario.
  def getting_name_age
    common_arr = []
    print 'Age: '
    person_age = gets.chomp.to_i
    print 'Name: '
    person_name = gets.chomp
    common_arr << person_age
    common_arr << person_name
  end

  # Lista todas las personas (estudiantes y profesores) disponibles en la aplicación.
  def list_all_people
    @people.each do |person_item|
      puts "[#{person_item.class}] Name: #{person_item.name}, ID: #{person_item.id}, Age: #{person_item.age}"
    end
  end

  # Permite al usuario crear un nuevo alquiler seleccionando un libro y una persona.
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

  # Lista todos los alquileres de una persona específica seleccionada por su ID.
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

# Define una función que presenta opciones al usuario.
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

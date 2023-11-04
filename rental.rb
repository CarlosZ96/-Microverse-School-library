require_relative 'book'
require_relative 'person'
class Rental
  attr_accessor :date, :book, :person

  def initialize(date, book, person)
    @date = date
    @book = book
    @person = person
    book.rentals << self unless book.rentals.include?(self)
    person.rentals << self unless person.rentals.include?(self)
  end

  def to_hash
    {
      date: @date,
      book: @book.title,
      person_id: @person.id
    }
  end
end

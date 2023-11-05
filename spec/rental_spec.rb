require_relative '../rental'
require_relative '../person'
require_relative '../book'

describe Rental do
  let(:person) { Person.new(22, 'Max Mustermann') }
  let(:book) { Book.new('The Pragmatic Programmer', 'Andy Hunt & Dave Thomas') }
  let(:rental) { Rental.new('2023-04-01', book, person) }

  describe '#new' do
    it 'creates a new rental with a date, book, and person' do
      expect(rental).to have_attributes(date: '2023-04-01')
      expect(rental.book).to eq book
      expect(rental.person).to eq person
    end
  end

  describe 'associations' do
    it 'associates a book with a person' do
      expect(book.rentals).to include(rental)
      expect(person.rentals).to include(rental)
    end
  end
end

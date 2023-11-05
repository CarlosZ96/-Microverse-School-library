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
  describe '#to_hash' do
    it 'returns a hash with the rental details' do
      hash = rental.to_hash
      expect(hash).to be_a(Hash)
      expect(hash[:date]).to eq('2023-04-01')
      expect(hash[:book]).to eq(book.title)
      expect(hash[:person_id]).to eq(person.id)
    end
  end
end

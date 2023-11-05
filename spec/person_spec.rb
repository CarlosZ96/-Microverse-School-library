require_relative '../person'
require_relative '../rental'
require_relative '../book'

describe Person do
  before :each do
    @person = Person.new(24, 'John Doe')
  end

  describe '#new' do
    it 'takes two parameters and returns a Person object' do
      expect(@person).to be_an_instance_of Person
    end

    it 'has a name' do
      expect(@person.name).to eql 'John Doe'
    end

    it 'has an age' do
      expect(@person.age).to eql 24
    end
  end

  describe '#rentals' do
    it 'should have an empty array of rentals at the start' do
      expect(@person.rentals).to eql []
    end

    it 'can have new rentals added' do
      book = Book.new('1984', 'George Orwell')
      rental = Rental.new('2023-04-01', book, @person)
      expect(@person.rentals).to include(rental)
    end
  end

  describe '#add_rental' do
    it 'adds a rental to the person' do
      book = Book.new('The Hobbit', 'J.R.R. Tolkien')
      rental = @person.add_rental('2023-05-01', book)
      expect(@person.rentals).to include(rental)
      expect(rental.person).to be @person
    end
  end
  describe '#to_hash' do
    it 'returns a hash with person details' do
      hash = @person.to_hash
      expect(hash).to be_a(Hash)
      expect(hash[:id]).to eq(@person.id)
      expect(hash[:name]).to eq('John Doe')
      expect(hash[:age]).to eq(24)
      expect(hash[:parent_permission]).to eq(true)
    end
  end
end

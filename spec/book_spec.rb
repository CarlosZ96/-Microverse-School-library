require './book'

describe Book do
  before :each do
    @book = Book.new('1984', 'George Orwell')
  end

  describe '#new' do
    it 'takes two parameters and returns a Book object' do
      expect(@book).to be_an_instance_of(Book)
    end
  end

  describe '#title' do
    it 'returns the correct title' do
      expect(@book.title).to eql('1984')
    end
  end

  describe '#author' do
    it 'returns the correct author' do
      expect(@book.author).to eql('George Orwell')
    end
  end

  describe '#add_rental' do
    it 'correctly adds a rental' do
      person = double('Person')
      allow(person).to receive(:rentals).and_return([])
      allow(person).to receive(:add_rental)

      date = '2021/04/23'
      expect do
        @book.add_rental(person, date)
      end.to change { @book.rentals.length }.by(2)
    end
  end
end

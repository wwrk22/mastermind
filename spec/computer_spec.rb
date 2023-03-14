require_relative '../lib/computer'


RSpec.describe Computer do
  # Suppress stdout and stderr messages on console.
  before :all do
    @stdout = $stdout
    @stderr = $stderr
    $stdout = File.open(File::NULL, 'w')
    $stderr = File.open(File::NULL, 'w')
  end


  describe "#random_guess" do
    subject(:computer) { described_class.new }

    it "returns an array of four randomly generated integers, all within [0,5]" do
      guess = computer.random_guess
      expect(guess).to be_valid_guess
    end
  end


  describe "#create_guess_pool" do
    subject(:computer) { described_class.new }

    it "returns an array of 1296 guesses that are all unique" do
      guess_pool = computer.create_guess_pool
      expect(guess_pool).to be_valid_guess_pool
    end
  end


  after :all do
    $stdout = @stdout
    $stderr = @stderr
    @stdout = nil
    @stderr = nil
  end
end

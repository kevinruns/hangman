# hangman game class
class Hangman
  attr_reader :word_to_find

  def initialize
    @word_to_find = []
    @word_array = File.read("5desk.txt").split("\r\n")
    @selected_letters = []
    @no_of_guesses = 6
  end

  def select_word
    unless word_to_find.length > 4 && word_to_find.length < 13
      @word_to_find = @word_array[rand(@word_array.length)].split("")
    end
  end

  def display_word
    print "\n"
    word_found = true
    @word_to_find.each do |letter|
      if @selected_letters.include?(letter.downcase)
        print " #{letter} "
      else
        print " - "
        word_found = false
      end
    end
    print "\n\n*****************************************************************************\n"
    print "\nCongratulations you have found the word!\n\n" if word_found == true
    word_found
  end

  def select_letter
    print "\nNumber of guesses remaining: #{@no_of_guesses} \n"
    print "Selected letters: #{@selected_letters.join(" ")}\n\n"
    print "Please select a letter: "
    letter = gets.chomp.downcase
    @selected_letters.push(letter)
    @word_to_find.include?(letter) ? true : false
  end

  def play_game
    select_word
    while !display_word && @no_of_guesses.positive?
      @no_of_guesses -= 1 unless select_letter
    end
    print "\nSorry no more guesses\n\n" if @no_of_guesses.zero?
  end
end

hang = Hangman.new
hang.play_game

require "yaml"
require 'pry'

# class to load word library
class WordLibrary
  attr_reader :word_to_find

  def initialize
    @word_to_find = []
    @word_array = File.read("5desk.txt").split("\r\n")
  end

  def select_word
    unless word_to_find.length > 4 && word_to_find.length < 13
      @word_to_find = @word_array[rand(@word_array.length)].split("")
    end
  end
end

# hangman game class
class PlayGame
  attr_writer :word_to_find

  def initialize
    @word_to_find = []
    @selected_letters = []
    @no_of_guesses = 6
  end

  def word_found
    print "\nWORD TO FIND: "
    word_found = true
    @word_to_find.each do |letter|
      if @selected_letters.include?(letter.downcase)
        print " #{letter} "
      else
        print " - "
        word_found = false
      end
    end
    print "\n"
    print "\nCongratulations you have found the word!\n\n" if word_found == true
    word_found
  end

  def select_letter
    print "\nPlease select a letter: "
    letter = gets.chomp.downcase
    @selected_letters.push(letter)
    @word_to_find.include?(letter) ? true : false
  end

  def player_save_option
    save_option = ''
    while save_option != 'Y' && save_option != 'N'
      print "\nWould you like to save your game? Y/N : "
      save_option = gets.chomp.upcase
    end
    if save_option == 'Y'
      print "Saving game... \n"
      save_game
      true
    else
      false
    end
  end

  def save_game
    Dir.mkdir("saved_games") unless Dir.exist?("saved_games")
    filename = "saved_games/#{object_id}.yml"

    File.open(filename, "w") do |file|
      file.puts YAML::dump(self)
      file.puts ""
    end
  end

  def play_game
    while !word_found && @no_of_guesses.positive?
      print "\nNumber of guesses remaining: #{@no_of_guesses} \n"
      print "Selected letters: #{@selected_letters.join(" ")}\n"
      return if player_save_option
      @no_of_guesses -= 1 unless select_letter
    end
    print "\nSorry no more guesses\n\n" if @no_of_guesses.zero?
  end
end

# game class
class Hangman
  def setup_game
    setup_option = ''
    while (setup_option != 'Y' && setup_option != 'N')
      print "\nWould you like to load a saved game? Y/N : "
      setup_option = gets.chomp.upcase
    end
    if setup_option == 'Y'
      print "Loading game... \n"
      load_game
    else
      new_game
    end
  end

  def new_game
    hang = PlayGame.new
    words = WordLibrary.new
    hang.word_to_find = words.select_word
    hang.play_game
  end

  def load_game
    files = Dir.entries("saved_games/.")
    files.delete('.')
    files.delete('..')
    print "Files: #{files.join(" ")} \n"
    file = select_file(files)
    hang = YAML.load_file("saved_games/#{file}")
    hang.play_game
  end

  def select_file(files)
    file = ""
    until files.include?(file)
      print "\nPlease enter file: "
      file = gets.chomp
    end
    file
  end
end

hang_one = Hangman.new
hang_one.setup_game

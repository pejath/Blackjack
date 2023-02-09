# frozen_string_literal: true

require_relative 'player'
require_relative 'deck'
require_relative 'game'
require_relative 'interface'

puts 'What is your name'
name = gets.chomp
players = [Player.new(name: name, role: :human, bank: 10), Player.new]
int = Interface.new(players)
int.start

# frozen_string_literal: true

require_relative 'player'
require_relative 'deck'
require_relative 'game'
require_relative 'interface'

puts 'What is your name'
players = [Player.new(name: gets.chomp, role: :human), Player.new]
int = Interface.new(players)
int.start

# frozen_string_literal: true

require 'pry'

class Game
  attr_accessor :deck, :human, :bots, :bank, :all_players

  def initialize(options = {})
    @all_players = options[:players]
    @deck = Deck.new
    @human = @all_players.find { |player| player.role == :human }
    @bots = @all_players.reject { |player| player.role == :human }
    @bank = 0
    next_round
  end

  def add_card(player)
    player.hand << @deck.take_card if player.hand.size < 3
  end

  def result
    @all_players.sort_by do |player|
      if (21 - player.convert_hand).negative?
        (21 - player.convert_hand).abs + 30
      else
        (21 - player.convert_hand)
      end
    end
  end

  def who_won?
    res = result
    if res[0].convert_hand != res[1].convert_hand
      puts "#{res[0].name} won"
    else
      puts 'Draw'
    end
  end

  def next_round
    res = result
    if res[0].convert_hand != res[1].convert_hand
      res.first.bank += @bank
    else
      @all_players.each { |p| p.bank += 10 }
    end
    return end_game if @human.bank.zero? || @bots.map(&:bank).sum.zero?

    @bank = 0
    @deck = Deck.new
    @all_players.each do |player|
      player.hand = []
      next unless player.bank.positive?

      2.times { add_card(player) }
      @bank += 10
      player.make_bet
    end
  end

  def end_game
    raise "your bank: #{@human.bank}.\nDo you want play again?"
  end
end

# frozen_string_literal: true

require 'pry'

class Game
  attr_accessor :deck, :human, :bots, :bank, :all_players
  PICTURE = 10
  MAX_POINT = 21
  ACE_VALUE_MIN = 1
  ACE_VALUE_MAX = 11

  def initialize(options = {})
    @all_players = options[:players]
    @deck = Deck.new
    @human = @all_players[0]
    @bots = @all_players[1..]
    @bank = 0
  end

  def add_card(player)
    player.hand << @deck.take_card if player.hand.size < 3
  end

  def result
    @all_players.sort_by { |player| (MAX_POINT - player.convert_hand).abs }
  end

  def who_won?
    res = result
    if res[0] != res[1]
      if (MAX_POINT - res[0].convert_hand) >= 0
        puts "#{res[0].name} won"
      elsif (MAX_POINT - res[1].convert_hand) >= 0
        puts "#{res[1].name} won"
      else
        puts "#{res.find{|p| MAX_POINT - p.convert_hand >= 0}}"
      end
    else
      puts 'Draw'
    end
  end

  def next_round
    res = result
    if res[0] != res[1]
    if (MAX_POINT - res[0].convert_hand) >= 0
      res[0].bank += @bank
    elsif (MAX_POINT - res[1].convert_hand) >= 0
      res[1].bank += @bank
      else
        res.find{|p| MAX_POINT - p.convert_hand >= 0}
      end
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

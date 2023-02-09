# frozen_string_literal: true

require 'pry'
class Player
  attr_accessor :hand, :name, :bank, :role

  def initialize(options = {})
    @hand = []
    @role = options[:role] || :bot
    @bank = options[:bank] || 100
    @name = options[:name] || 'Dealer'
  end

  def make_bet
    if (@bank - 10).negative? && 10.positive?
      0
    else
      @bank -= 10
    end
  end

  def convert_hand
    @hand_value = 0
    hand = @hand.map(&:chop)
    hand.each do |card|
      @hand_value += card.to_i
    end

    hand.sort.reverse.each do |card|
      @hand_value += Game::PICTURE if %w[Q K J].include?(card)
      if card == 'A' && @hand_value + Game::ACE_VALUE_MAX > Game::MAX_POINT
        @hand_value += Game::ACE_VALUE_MIN
      elsif card == 'A' && @hand_value + Game::ACE_VALUE_MAX <= Game::MAX_POINT
        @hand_value += Game::ACE_VALUE_MAX
      end
    end
    @hand_value = MAX_POINT if hand.size == 2 && [hand[0], hand[1], 'A'].uniq.size <= 1

    @hand_value
  end
end

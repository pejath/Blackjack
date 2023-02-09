# frozen_string_literal: true

class Player
  attr_accessor :hand, :name, :bank, :role, :hand_v

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
    @hand_v = 0
    hand = @hand.map(&:chop)
    hand.each do |card|
      @hand_v += card.to_i
    end

    hand.sort.reverse.each do |card|
      @hand_v += 10 if %w[Q K J].include?(card)
      if card == 'A' && @hand_v + 11 > 21
        @hand_v += 1
      elsif card == 'A' && @hand_v + 11 <= 21
        @hand_v += 11
      end
    end
    @hand_v
  end
end

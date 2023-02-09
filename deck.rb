# frozen_string_literal: true

class Deck
  attr_accessor :deck

  SYMBOLS = %w[♠ ♥ ♦ ♣].freeze
  NUMS = (2..10).to_a
  PICTURES = %w[J Q K A].freeze

  def initialize
    (NUMS + PICTURES).each do |card|
      SYMBOLS.each do |sym|
        @deck ||= []
        @deck << "#{card}#{sym}"
      end
    end
    @deck.shuffle!
  end

  def take_card
    deck.delete_at(0)
  end
end

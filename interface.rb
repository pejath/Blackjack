# frozen_string_literal: true

class Interface
  def initialize(players)
    @game = Game.new(players: players)
  end

  def start
    show_table

    print '-> '
    command = gets.chomp

    case command
    when 'help'
      puts ''
    when 'pass'
      bot_actions(@game.bots)
    when 'take'
      @game.add_card(@game.human) if @game.human.hand.size < 3
      bot_actions(@game.bots)
      open_table
      @game.next_round
    when 'open'
      open_table
      @game.next_round
    when 'exit'
      return
    end

    start
  rescue StandardError => e
    puts e
    if gets.chop.downcase == 'yes'
      players = @game.all_players.each do |p|
        p.bank = 100
        p.hand = []
      end
      i = Interface.new(players)
      i.start
    end
  end

  def show_table
    puts "\e[H\e[2J"
    @game.bots.map { |bot| print "\t #{bot.name}" }
    puts ''
    @game.bots.map { |bot| print "\t #{'*' * bot.hand.size}" }
    puts ''
    print "Bank:#{@game.bank} #{"\t" * (@game.bots.count + 1)} Your hand: #{@game.human.convert_hand}"
    puts "\n\tYour bank: #{@game.human.bank}\n\tYour hand: #{@game.human.hand.join(' ')}"
  end

  def open_table
    puts "\e[H\e[2J"
    @game.bots.map { |bot| print "\t#{bot.name}" }
    puts ''
    @game.bots.map { |bot| print "\t #{bot.hand.join(' ')}" }
    puts ''
    @game.bots.map { |bot| print "\t #{bot.convert_hand}" }
    puts ''
    print "Bank:#{@game.bank} #{"\t" * (@game.bots.count + 1)} Your hand: #{@game.human.convert_hand}"
    puts "\n\tYour bank: #{@game.human.bank}\n\tYour hand: #{@game.human.hand.join(' ')}"
    @game.who_won?
    print 'press any button to continue'
    gets.chomp
  end

  def bot_actions(bots)
    bots.each do |bot|
      @game.add_card(bot) if bot.convert_hand < 17 && bot.hand.size < 3
    end
  end
end

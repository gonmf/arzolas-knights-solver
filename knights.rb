def read_game_string(str)
  width, height, board, pieces = str.downcase.split(';')
  raise 'Illegal board' if pieces.nil?

  width = width.to_i + 4
  height = height.to_i + 4

  lg_board = (0..(width * 2 - 1)).map { 'x' }.join
  board.chars.each_slice(width - 4) do |chrs|
    lg_board += "xx#{chrs.join}xx"
  end
  lg_board += (0..(width * 2 - 1)).map { 'x' }.join

  lg_pieces = (0..(width * 2 - 1)).map { '.' }.join
  pieces.chars.each_slice(width - 4) do |chrs|
    lg_pieces += "..#{chrs.join}.."
  end
  lg_pieces += (0..(width * 2 - 1)).map { '.' }.join

  knight_moves = [
    -2 - width,
    -1 - width - width,
     1 - width - width,
     2 - width,
     2 + width,
     1 + width + width,
    -1 + width + width,
    -2 + width
  ]

  {
    width: width,
    height: height,
    board: lg_board,
    pieces: lg_pieces,
    knight_moves: knight_moves.freeze
  }
end

def game_dup(game)
  {
    width: game[:width],
    height: game[:height],
    board: game[:board],
    pieces: game[:pieces].dup,
    knight_moves: game[:knight_moves].dup
  }
end

def valid_plays(game)
  valid = []

  game[:pieces].chars.each_with_index do |val, num|
    if %w[r b y].include?(val)
      candidates = game[:knight_moves].map do |diff|
        num + diff
      end

      candidates = candidates.select do |pos|
        game[:board][pos] != 'x' && game[:pieces][pos] == '.'
      end

      valid = valid + candidates.map { |to| [num, to] }
    end
  end

  valid
end

def game_over?(game)
  ((0..(game[:width] * game[:height] - 1)).find do |num|
    game[:board][num] == 'r' && game[:pieces][num] != 'r' ||
    game[:board][num] == 'b' && game[:pieces][num] != 'b'
  end).nil?
end

def random_search(game, depth, depth_limit, past_pieces)
  depth += 1
  return [nil] if depth >= depth_limit

  possible_plays = valid_plays(game)

  possible_plays = possible_plays.select do |pair|
    from, to = pair

    pieces = game[:pieces].dup
    pieces[to] = pieces[from]
    pieces[from] = '.'

    !past_pieces.include?(pieces.hash)
  end

  return [nil] if possible_plays.empty? # dead end

  from, to = possible_plays.sample

  game[:pieces][to] = game[:pieces][from]
  game[:pieces][from] = '.'

  return [nil] if past_pieces.include?(game[:pieces].hash)

  return ["#{from},#{to}", 'END'] if game_over?(game)

  ["#{from},#{to}"] + random_search(game, depth, depth_limit, past_pieces + [game[:pieces].hash])
end

def pretty_pos(game, pos)
  pos = pos.to_i

  left = (pos % game[:width]) - 2
  top = (pos / game[:width]) + 2

  "#{('A'.ord + left).chr}#{game[:height] - top}"
end

def pretty_play(game, play)
  from, to = play.split(',')

  "#{pretty_pos(game, from)}-#{pretty_pos(game, to)}"
end

def pretty_play_sequence(game, plays)
  plays.compact.map do |play|
    pretty_play(game, play)
  end.join(', ')
end

def start_search(game)
  tries = 0
  best_result = nil
  depth_limit = 80

  while true do
    tries += 1
    print "\r#{tries}" if (tries % 1024) == 0

    new_game = game_dup(game)
    result = random_search(new_game, 0, depth_limit, [new_game[:pieces].hash])

    if result[result.count - 1] == 'END'
      result = result[0..(result.count - 2)]
      if best_result.nil? || best_result.count > result.count
        puts
        puts "Found at try ##{tries} (size #{result.count}, new record)"
        best_result = result.dup
        depth_limit = result.count
        puts pretty_play_sequence(game, best_result)
      end
    end
  end
end

# Puzzle pack Queen board C3:
game_string = '4;5;rxxbb..rx..xx..xx..x;b..rryyb.yy......yy.'

# Output:
# Found at try #35070 (size 51, new record)
# D4-C2, A4-B2, C3-A4, B3-D4, D5-C3, D4-B3, C2-D4, B4-D5, D4-C2, B3-D4, C2-B4, A5-B3, C4-A5, B2-C4, A4-B2, C3-A4, B4-C2, D5-C3, C2-B4, B4-D5, D4-C2, C2-B4, B3-D4, D4-C2, A5-B3, C4-A5, B2-C4, B3-D4, C4-B2, A5-B3, B2-C4, C4-A5, A4-B2, C3-A4, B2-C4, A4-B2, D5-C3, B4-D5, C3-A4, D5-C3, C2-B4, D4-C2, B4-D5, C2-B4, B3-D4, B4-C2, A5-B3, D5-B4, C4-A5, B2-C4, B4-D5

game = read_game_string(game_string)

start_search(game)

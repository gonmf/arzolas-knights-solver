def read_game_string(str)
  width, height, board, pieces = str.downcase.split(';')
  raise 'Illegal board' if pieces.nil?

  width = width.to_i

  knight_moves = [
    -2 - width,
    -1 - width - width,
     1 - width - width,
     2 - width,
     2 + width,
     1 + width + width,
     1 + width + width,
    -2 + width
  ]

  {
    width: width,
    height: height.to_i,
    board: board,
    pieces: pieces,
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
        pos >= 0 && pos < game[:width] * game[:height] &&
        game[:board][pos] != 'x' && game[:pieces][pos] == '.'
      end

      valid = valid + candidates.map { |to| [num, to] }
    end
  end

  valid
end

def game_over?(game)
  ((0..(game[:width] * game[:height])).find do |num|
    game[:board][num] == 'r' && game[:pieces][num] != 'r' ||
    game[:board][num] == 'b' && game[:pieces][num] != 'b'
  end).nil?
end

def random_search(game, depth, depth_limit)
  depth += 1
  return [nil] if depth >= depth_limit

  while true do
    possible_plays = valid_plays(game)
    return [nil] if possible_plays.empty? # dead end

    from, to = possible_plays.sample

    color = game[:pieces][from]
    game[:pieces][from] = '.'
    game[:pieces][to] = color

    if game_over?(game)
      return ['END']
    end

    return ["#{from},#{to}"] + random_search(game, depth, depth_limit)
  end
end

def pretty_pos(game, pos)
  pos = pos.to_i

  left = pos % game[:width]
  top = pos / game[:width]

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
  depth_limit = 20

  while true do
    tries += 1

    result = random_search(game_dup(game), 0, depth_limit)

    if result[result.count - 1] == 'END'
      if best_result.nil? || best_result.count > result.count
        puts "Found at try ##{tries} (size #{result.count - 1}, new record)"
        best_result = result.dup
        depth_limit = result.count
        puts pretty_play_sequence(game, best_result)
      end
    end
  end
end

game_string = '4;5;rxxbb..rx..xx..xx..x;b..rryyb.yy......yy.'
# Solution:
# D4-B2, B4-C2, D5-B4, B3-D4, A5-B3, B3-D5, C4-A5, A5-B3, A4-C4, C4-A5, B2-A4, D4-B2

puts start_search(read_game_string(game_string))

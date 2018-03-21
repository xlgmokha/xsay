module Xsay
  class Render
    attr_reader :colour, :distance, :speed

    def initialize(
      colour: options[:colour].to_sym,
      distance: options[:distance],
      speed: options[:speed]
    )
      @colour = colour.to_sym
      @distance = distance
      @speed = speed
    end

    def render(message, template)
      message = message.join(' ') if message.respond_to?(:join)
      line_break = "-" * message.length
      move = distance > 0
      distance.downto(0) do |n|
        system 'clear' if move
        spaces = " " * n
        result = <<-MESSAGE
  #{line_break}
< #{n.even? ? message : ' ' * message.length} >
  #{line_break}

#{template.gsub(/^/, "#{spaces}")}
        MESSAGE
        if colour == :rainbow
          result.each_char.each_with_index do |x, i|
            print x.colorize(String.colors[i % String.colors.size])
          end
        else
          puts result.colorize(colour)
        end
        sleep speed if move
      end
      nil
    end

  end
end

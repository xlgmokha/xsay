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
      each_frame do |frame|
        draw(message, template, line_break, frame)
      end
      nil
    end

    def each_frame
      return yield 0 unless move?
      frames = distance.downto(0).to_a + 0.upto(distance).to_a
      frames.each { |x| yield x }
    end

    private

    def draw(message, template, line_break, frame)
        system 'clear' if move?
        spaces = " " * frame
        result = <<-MESSAGE
  #{line_break}
< #{frame.even? ? message : ' ' * message.length} >
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
        sleep speed if move?
    end

    def move?
      distance > 0
    end
  end
end

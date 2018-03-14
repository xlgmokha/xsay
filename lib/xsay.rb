require "xsay/version"
require "thor"
require "colorize"

module Xsay
  class CLI < Thor
    ANIMALS=Dir[File.expand_path("xsay/templates/*.template", File.dirname(__FILE__))]
    class_option :colour, default: :default, required: false
    class_option :distance, default: 1, required: false, type: :numeric
    class_option :speed, default: 1, required: false, type: :numeric

    ANIMALS.each do |filename|
      animal = File.basename(filename).split(".")[0]

      desc "#{animal} <message>", "xsay #{animal} hello"
      define_method animal do |*args|
        render(args, IO.read(filename))
      end
    end

    desc "all <message>", "xsay all hello"
    def all(*args)
      animals = public_methods - Thor.new.methods - [:random, :all]
      animals.each { |x| public_send(x, *args) }
      nil
    end

    desc "random <message>", "xsay random hello"
    def random(*args)
      random_colour = (String.colors + [:rainbow]).sample
      render(args, IO.read(ANIMALS.shuffle.sample), colour: random_colour)
    end

    private

    def render(
      message,
      template,
      colour: options[:colour].to_sym,
      distance: options[:distance],
      speed: options[:speed]
    )
      message = message.join(' ') if message.respond_to?(:join)
      line_break = "-" * message.length
      move = distance > 1
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
          say result.colorize(colour)
        end
        sleep speed if move
      end
      nil
    end
  end
end

require "xsay/version"
require "thor"
require "colorize"

module Xsay
  class CLI < Thor
    ANIMALS=Dir[File.expand_path("xsay/templates/*.template", File.dirname(__FILE__))]

    ANIMALS.each do |filename|
      animal = File.basename(filename).split(".")[0]

      desc "#{animal} <message>", "xsay #{animal} hello"
      define_method animal do |*args|
        render(args, IO.read(filename))
      end
    end

    desc "all <message>", "xsay all hello"
    def all(*args)
      ANIMALS.each do |filename|
        render(args, IO.read(filename))
      end
    end

    desc "random <message>", "xsay random hello"
    def random(*args)
      render(args, IO.read(ANIMALS.shuffle.sample), colour: String.colors.sample)
    end

    desc "rainbow <message>", "xsay rainbow hello world"
    def rainbow(*args)
      render(args, IO.read(ANIMALS.shuffle.sample), colour: :rainbow)
    end

    private

    def render(message, template, colour: :default)
      message = message.join(' ') if message.respond_to?(:join)
      line_break = "-" * message.length
      result = <<-MESSAGE
  #{line_break}
< #{message} >
  #{line_break}

#{template}
      MESSAGE
      if colour == :rainbow
        result.each_char.each_with_index do |x, i|
          print x.colorize(String.colors[i % String.colors.size])
        end
      else
        puts result.colorize(colour)
      end
    end
  end
end

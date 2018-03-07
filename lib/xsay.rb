require "xsay/version"
require "thor"
require "colorize"

module Xsay
  class CLI < Thor
    ANIMALS=Dir[File.expand_path("xsay/templates/*.template", File.dirname(__FILE__))]
    class_option :colour, default: :default, required: false

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
      random_color = (String.colors + [:rainbow]).sample
      render(args, IO.read(ANIMALS.shuffle.sample), colour: random_color)
    end

    private

    def render(message, template, colour: options[:colour].to_sym)
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
        say result.colorize(colour)
      end
      nil
    end
  end
end

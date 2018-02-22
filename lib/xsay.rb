require "xsay/version"
require "thor"

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
      render(args, IO.read(ANIMALS.shuffle.sample))
    end

    private

    def render(message, template)
      message = message.join(' ') if message.respond_to?(:join)
      line_break = "-" * message.length
      say <<-MESSAGE
  #{line_break}
< #{message} >
  #{line_break}

#{template}
      MESSAGE
    end
  end
end

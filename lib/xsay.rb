require "xsay/version"
require "thor"

module Xsay
  class CLI < Thor
    Dir[File.expand_path("xsay/templates/*.template", File.dirname(__FILE__))].each do |filename|
      animal = File.basename(filename).split(".")[0]

      desc "#{animal} <message>", "xsay #{animal} hello"
      define_method animal do |message|
        render(message, IO.read(filename))
      end
    end

    private

    def render(message, template)
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

require "xsay/version"
require "thor"

module Xsay
  class CLI < Thor
    desc "cat <message>", "xsay cat meow"
    def cat(message)
      template = <<-MESSAGE
    ("`-''-/").___..--''"`-._
     `6_ 6  )   `-.  (     ).`-.__.`)
     (_Y_.)'  ._   )  `._ `. ``-..-'
   _..`--'_..-_/  /--'_.' ,'
  (il),-''  (li),'  ((!.-'
      MESSAGE
      render(message, template)
    end

    desc "hippo <message>", "xsay hippo meow"
    def hippo(message)
      template = IO.read(File.expand_path('xsay/templates/hippo.template', File.dirname(__FILE__)))
      render(message, template)
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

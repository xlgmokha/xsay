require "thor"
require "colorize"
require "xsay/render"
require "xsay/version"

module Xsay
  class CLI < Thor
    ANIMALS=Dir[File.expand_path("xsay/templates/*.template", File.dirname(__FILE__))]
    class_option :colour, default: :default, required: false
    class_option :distance, default: 0, required: false, type: :numeric
    class_option :speed, default: 1, required: false, type: :numeric

    ANIMALS.each do |filename|
      animal = File.basename(filename).split(".")[0]

      desc "#{animal} <message>", "xsay #{animal} hello"
      define_method animal do |*args|
        renderer.render(args, IO.read(filename))
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
      renderer.render(args, IO.read(ANIMALS.shuffle.sample), colour: random_colour)
    end

    private

    def renderer
      Render.new(
        colour: options[:colour].to_sym,
        distance: options[:distance],
        speed: options[:speed]
      )
    end
  end
end

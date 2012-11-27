#!/usr/bin/env ruby

require 'bundler/setup'
Bundler.require(:default, :development)

require 'yaml'

config = Hashie::Mash.new(YAML.load_file('./gloat.yaml'))

files = []

config.slides.each do |entry|
  if File.directory?(entry)
    files += Dir[File.expand_path(File.join('..', entry, '*'), __FILE__)]
  else
    files << File.expand_path(File.join('..', entry), __FILE__)
  end
end

class Slide

  attr_reader :number, :header, :markup, :template_name

  def initialize number, header, content, template_name='default'
    @number = number
    @markup = Tilt::RedClothTemplate.new { content }.render
    @header = header
    @template_name = template_name
  end

  def render
    @render ||= begin
      template.render(self)
    end
  end

  private

  def template
    @template ||= Tilt::ERBTemplate.new(template_file)
  end

  def template_file
    File.expand_path(File.join('..', 'templates', "#{template_name}.erb"), __FILE__)
  end
end

class Page

  attr_reader :config, :slides, :layout_name

  def initialize config, slides, layout_name='default'
    @config = config
    @slides = slides
    @layout_name = layout_name
  end

  def render
    layout.render(self) { slides.map { |s| s.render }.join("\n") }
  end

  def title
    config.name
  end

  def description
    config.description
  end

  def author
    config.author
  end

  private

  def layout
    @layout ||= Tilt::ERBTemplate.new(layout_file)
  end

  def layout_file
    File.expand_path(File.join('..', 'layouts', "#{layout_name}.erb"), __FILE__)
  end
end

number = 1
slides = []
header_regex = /^!SLIDE\s*/
slide_regex = /(?m)#{header_regex}.*?(?=#{header_regex}|\Z)/

files.each do |file|
  next unless File.exist?(file)
  File.read(file).scan(slide_regex).each do |s|
    m = s.match(/!SLIDE\s*(.*)\s*\n+(.+)\n*/)
    header = m[1]
    content = m[2]

    slide = Slide.new(number, header, content)

    slides << slide
    number += 1
  end
end

p = Page.new(config, slides)
puts p.render

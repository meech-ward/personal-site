require 'kramdown'

module Jekyll
  class MyLiquidTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
      @tokens = tokens
      @tag_name = tag_name
    end

    def renderMarkdown(markdown)
      Kramdown::Document.new(markdown).to_html
    end
  end
end
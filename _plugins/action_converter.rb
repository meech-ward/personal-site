require 'rouge'

module Jekyll
  class ActionConverter < Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /^\.md$/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      html = Kramdown::Document.new(content, {syntax_highlighter: "rouge"}).to_html
      return html
    end
  end
end
require_relative 'my_liquid_tag' 

module Jekyll
  class DeletedTag < MyLiquidTag

    def render(context)
      html = renderMarkdown @text
      "<div class=\"deleted\">#{html}</div>"
    end

  end
end

Liquid::Template.register_tag('deleted', Jekyll::DeletedTag)
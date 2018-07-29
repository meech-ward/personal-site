require_relative 'my_liquid_tag' 

module Jekyll
  class ActionTag < MyLiquidTag

    def render(context)
      html = renderMarkdown @text
      "<div class=\"action\">#{html}</div>"
    end
  end
end

Liquid::Template.register_tag('action', Jekyll::ActionTag)
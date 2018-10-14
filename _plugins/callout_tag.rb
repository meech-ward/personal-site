require_relative 'my_liquid_tag' 

module Jekyll
  class ActionTag < MyLiquidTag
    def render(context)
      html = renderMarkdown @text
      "<div class=\"action\">#{html}</div>"
    end
  end

  class NoteTag < MyLiquidTag
    def render(context)
      html = renderMarkdown @text
      "<div class=\"action\">NOTE: #{html}</div>"
    end
  end

  class AttentionTag < MyLiquidTag
    def render(context)
      html = renderMarkdown @text
      "<div class=\"action\">NOTE: #{html}</div>"
    end
  end

  class WarningTag < MyLiquidTag
    def render(context)
      html = renderMarkdown @text
      "<div class=\"action\">NOTE: #{html}</div>"
    end
  end

  class ImportantTag < MyLiquidTag
    def render(context)
      html = renderMarkdown @text
      "<div class=\"action\">NOTE: #{html}</div>"
    end
  end
end

Liquid::Template.register_tag('action', Jekyll::ActionTag)
Liquid::Template.register_tag('note', Jekyll::NoteTag)
Liquid::Template.register_tag('attention', Jekyll::AttentionTag)
Liquid::Template.register_tag('warning', Jekyll::WarningTag)
Liquid::Template.register_tag('important', Jekyll::ImportantTag)
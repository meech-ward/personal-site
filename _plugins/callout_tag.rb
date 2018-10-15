require_relative 'my_liquid_tag' 

module Jekyll
  class ActionTag < MyLiquidTag
    def render(context)
      html = renderMarkdown @text
      "<div class=\"callout callout--action\">#{html}</div>"
    end
  end

  class NoteTag < MyLiquidTag
    def render(context)
      html = renderMarkdown @text
      "<div class=\"callout callout--note\"><p>Note:</p>#{html}</div>"
    end
  end

  class SideNoteTag < MyLiquidTag
    def render(context)
      html = renderMarkdown "{:.smaller-text}"+@text
      html.sub! "<p>", "<p class=\"smaller-text\">"
      "<div class=\"callout callout--sidenote\">#{html}</div>"
    end
  end

  class AttentionTag < MyLiquidTag
    def render(context)
      html = renderMarkdown @text
      "<div class=\"callout callout--attention\">#{html}</div>"
    end
  end

  class WarningTag < MyLiquidTag
    def render(context)
      html = renderMarkdown @text
      "<div class=\"callout callout--warning\">#{html}</div>"
    end
  end

  class ImportantTag < MyLiquidTag
    def render(context)
      html = renderMarkdown @text
      "<div class=\"callout callout--important\">#{html}</div>"
    end
  end

  class AsideTag < MyLiquidTag
    def render(context)
      html = renderMarkdown @text
      "<aside class=\"callout callout--aside\"><p>#{html}</p></aside>"
    end
  end
end

Liquid::Template.register_tag('action', Jekyll::ActionTag)
Liquid::Template.register_tag('note', Jekyll::NoteTag)
Liquid::Template.register_tag('side_note', Jekyll::SideNoteTag)
Liquid::Template.register_tag('attention', Jekyll::AttentionTag)
Liquid::Template.register_tag('warning', Jekyll::WarningTag)
Liquid::Template.register_tag('important', Jekyll::ImportantTag)
Liquid::Template.register_tag('aside', Jekyll::AsideTag)
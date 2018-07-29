require_relative 'my_liquid_tag' 

module Jekyll
  class YoutubeTag < MyLiquidTag

    def render(context)
      "<iframe class=\"youtube-video\" width=\"100%\" height=\"400\" src=\"https://www.youtube.com/embed/#{@text}\" frameborder=\"0\" allow=\"autoplay; encrypted-media\" allowfullscreen></iframe>"
    end

  end
end

Liquid::Template.register_tag('youtube', Jekyll::YoutubeTag)
require_relative 'my_liquid_tag' 

module Jekyll
  class PostImageLargeTag < MyLiquidTag

    def render(context)
      return "<p class=\"post__image post__image--large\"><img  src=\"/assets/images/posts/#{@text}\" /></p>"
    end

  end
end

Liquid::Template.register_tag('post_image_large', Jekyll::PostImageLargeTag)
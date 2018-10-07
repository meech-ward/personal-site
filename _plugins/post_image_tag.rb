require_relative 'my_liquid_tag' 

module Jekyll
  class PostImageLargeTag < MyLiquidTag

    def render(context)
      return "<img class=\"post__image post__image--large\" src=\"/assets/images/posts/#{@text}\" />"
    end

  end
end

Liquid::Template.register_tag('post_image_large', Jekyll::PostImageLargeTag)
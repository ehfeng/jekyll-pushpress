module JekyllPushPress

  # class Generator < Jekyll::Generator
  #   safe true
  #   priority :lowest

  #   def generate(site)
  #     for doc in site.documents
  #       puts doc.content
  #     end

  #     # puts "Posts"
  #     # for post in site.posts.docs
  #     #   puts post.url
  #     #   puts post.collection.label
  #     # end
      
  #     # puts "Pages"
  #     # puts site.pages.length
  #     # for page in site.pages
  #     #   puts page.url
  #     #   puts page.collection.label
  #     # end
  #   end
  # end

  # Jekyll::Hooks.register :site, :post_render do |site|
  #   puts site.to_yaml
  # end

  # Jekyll::Hooks.register :pages, :post_render do |page|
  #   # puts page.url
  # end

  Jekyll::Hooks.register :documents, :pre_render do |doc|
    puts doc.data['layout'] = 'pushpress/pushpress'
  end

  private

  PREDEFINED_GLOBAL_VARIABLES = ["layout", "permalink", "published"]
end
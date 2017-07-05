require 'digest'
require 'json'

def process_collection(collection, site, body)
  body[collection.label] = []

  for doc in collection.docs
    md5 = Digest::MD5.new
    md5.update doc.content
    doc.path.slice! site.source
    body[collection.label].push({
      'url': doc.url,
      'hash': md5.hexdigest,
      'date': doc.date,
      'fields': doc.data,
      'path': doc.path,
    })
  end
  return body
end

module JekyllPushPress
  Jekyll::Hooks.register :site, :pre_render do |site|
    for doc in site.documents
      doc.data['layout'] = 'pushpress'
    end
  end

  Jekyll::Hooks.register :site, :post_render do |site|
    body = {
      :posts => [],
      :pages => [],
    }

    for page in site.pages
      md5 = Digest::MD5.new
      md5.update page.content
      body[:pages].push({'url': page.url, 'hash': md5.hexdigest, 'fields': page.data})
    end

    site.collections.each do |label, collection|
      if collection.label == 'posts'
        body = process_collection(collection, site, body)
      else
        if collection.write?
          body = process_collection(collection, site, body)
        end
      end
    end
    puts body.to_json
  end

  private

  PREDEFINED_GLOBAL_VARIABLES = ["layout", "permalink", "published"]
end
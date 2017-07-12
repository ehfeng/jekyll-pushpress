require 'base64'
require 'digest'
require 'json'

def process_collection(collection, site, mode)
  result = []

  for doc in collection.docs
    doc.path.slice! (site.source + '/')
    page_result = {
      'url': doc.url,
      'path': doc.path,
      'fields': doc.data,
    }

    if mode == 'hash'
      md5 = Digest::MD5.new
      md5.update doc.content
      page_result['hash'] = md5.hexdigest
    elsif mode == 'render'
      page_result['content'] = Base64.encode64(doc.content)
    end
    result.push(page_result)
  end

  result
end

module JekyllPushPress
  Jekyll::Hooks.register :site, :pre_render do |site|
    if ENV['PUSHPRESS_MODE'] == 'hash'
      site.time = Time.at(0)

      for doc in site.documents
        doc.data['layout'] = 'pushpress'
      end
    end
  end

  Jekyll::Hooks.register :site, :post_render do |site|
    mode = ENV['PUSHPRESS_MODE']

    body = {
      :pages => [],
    }

    for page in site.pages
      page_result = {
        'url': page.url,
        'path': page.path,
        'fields': page.data,
      }

      if mode == 'hash'
        md5 = Digest::MD5.new
        md5.update page.content
        page_result['hash'] = md5.hexdigest
      elsif mode == 'render'
        page_result['content'] = Base64.encode64(page.content)
      end
      
      body[:pages].push(page_result)
    end

    site.collections.each do |label, collection|
      if collection.label == 'posts'
        body[collection.label] = process_collection(collection, site, mode)
      else
        if collection.write?
          body[collection.label] = process_collection(collection, site, mode)
        end
      end
    end
    puts body.to_json
  end

  private

  PREDEFINED_GLOBAL_VARIABLES = ["layout", "permalink", "published"]
end
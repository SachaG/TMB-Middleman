###
# Blog settings
###

# Time.zone = "UTC"

activate :blog do |blog|
  # blog.prefix = "chapter"
  blog.sources = "book/:title.html"
  blog.permalink = ":title"
  # blog.sources = ":year-:month-:day-:title.html"
  # blog.taglink = "tags/:tag.html"
  # blog.layout = "layout"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = ":year.html"
  # blog.month_link = ":year/:month.html"
  # blog.day_link = ":year/:month/:day.html"
  # blog.default_extension = ".markdown"

  # blog.tag_template = "tag.html"
  # blog.calendar_template = "calendar.html"

  blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/:num"
end

page "/feed.xml", :layout => false
page "book/*", :layout => :page_layout

### 
# Compass
###

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
# 
# With no layout
# page "/path/to/file.html", :layout => false
# 
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
# 
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

set :fonts_dir, 'fonts'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css
  
  # Minify Javascript on build
  # activate :minify_javascript
  
  # Enable cache buster
  # activate :cache_buster
  
  # Use relative URLs
  # activate :relative_assets
  
  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher
  
  # Or use a different image path
  # set :http_path, "/Content/images/"
end

activate :directory_indexes

activate :syntax#,:linenos => 'table'

set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true, :smartypants => true

helpers do
  def div(css_class, content)
    %Q{<div class="#{css_class}">#{content}</div>}
  end
  def caption(content)
    %Q{<div class="caption">#{content}</div>}
  end
  def image(css_class, src, caption)
    %Q{<figure class="#{css_class}"><img src="#{src}" alt="#{caption}"/><figcaption>#{caption}</figcaption></figure>}
  end
  def diagram(name, caption)
    %Q{<figure class="diagram"><img src="/images/diagrams/#{name}@2x.png" alt="#{caption}"/><figcaption>#{caption}</figcaption></figure>}
  end
  def screenshot(name, caption)
    %Q{<figure class="screenshot"><img src="/images/screenshots/#{name}.png" alt="#{caption}"/><figcaption>#{caption}</figcaption></figure>}
  end    
  def commit(name, caption)
    %Q{<div class="commit"><a href="https://github.com/SachaG/Microscope/commits/master" target="_blank">Commit #{name}</a>: #{caption}</div>}
  end    
  def note(&block)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    content = markdown.render(capture(&block))
    concat %Q{<div class="note">#{content}</div>}
  end
  def chapter(&block)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    content = markdown.render(capture(&block))
    concat %Q{<div class="chapter">#{content}</div>}
  end
end

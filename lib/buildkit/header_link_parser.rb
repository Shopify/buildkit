module HeaderLinkParser
  module_function

  def parse_link_header(link_header)
    {}.tap do |hash_link|
      link_header.split(',').each do |link|
        link_obj = LinkParser.new(link)
        hash_link[link_obj.name] = link_obj.link
      end
    end
  end

  class LinkParser
    def initialize(value)
      @value = value
    end

    def name
      @name ||= @value[/rel="(.*)"/, 1].to_sym
    end

    def link
      @link ||= @value[/<(.+)>/, 1]
    end
  end
end

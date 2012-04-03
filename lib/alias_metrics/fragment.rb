module AliasMetrics
  class Fragment
    attr_accessor :body
    attr_accessor :count

    def initialize(body)
      self.body = body
      self.count = 0
    end

    def types
      body.size * count
    end

    def shorten_types(alias_)
      (body.size - alias_.size) * count
    end
  end
end

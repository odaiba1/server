class LinkShortener
  def initialize(url)
    @url = url
  end

  def call
    client = Bitly::API::Client.new(token: ENV['BITLY_TOKEN'])
    bitlink = client.shorten(long_url: @url)
    bitlink.link
  end
end

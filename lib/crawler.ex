defmodule Crawler do
  require Logger

  @host "http://www.naymspace.de"

  def crawl(url) do
    Logger.debug("crawling #{url}, already crawled #{MapSet.size LinkAgent.get_set}")

    HTTPoison.get!(@host <> url).body
    |> Floki.attribute("a", "href")
    |> Enum.map(fn url -> URI.parse(url) end)
    |> filter_links
    |> Enum.map(fn a -> a.path end)
    |> LinkAgent.add_urls
  end

  def filter_links(uris) do
    Enum.filter uris, fn (uri) ->
      %URI{host: host, path: path} = uri
      case host do
        @host -> true
          nil -> path && String.starts_with? path, "/"
            _ -> false
      end
    end
  end
end

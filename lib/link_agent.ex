defmodule LinkAgent do
  @name __MODULE__

  def start_link,
  do: Agent.start_link fn -> MapSet.new() end, name: @name

  def add_urls(urls),
  do: Agent.update @name, &add_urls(&1, urls)

  def get_set,
  do: Agent.get @name, &(&1)

  defp add_urls(set, urls),
  do: Enum.reduce urls, set, &add_url(&1, &2)

  defp add_url(url, set) do
    if !MapSet.member?(set, url), do: spawn Crawler, :crawl, [url]
    MapSet.put set, url
  end
end

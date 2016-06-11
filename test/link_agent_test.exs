defmodule LinkAgentTest do
  use ExUnit.Case, async: true
  doctest LinkAgent

  test "collects distinct urls" do
    LinkAgent.start_link
    assert [] == MapSet.to_list LinkAgent.get_set
    LinkAgent.add_urls(["first_url"])
    LinkAgent.add_urls(["second_url", "first_url"])
    LinkAgent.add_urls(["second_url"])
    assert ["first_url", "second_url"] == MapSet.to_list LinkAgent.get_set
  end
end

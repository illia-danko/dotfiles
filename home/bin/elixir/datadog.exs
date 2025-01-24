# Print kubernetes pod group logs of the given 'service' argument.
#
# Usage:
# elixir kubectl_logs.exs --n=ddi --service=device-operation

defmodule DatadogLogs do
  defp cli_options(args) do
    with {options, _args, _} <-
           OptionParser.parse(args,
             switches: [env: :string, term: :string]
           ) do
      {:ok, options}
    else
      reason -> {:error, reason}
    end
  end

  def main() do
    :ok = ensure_deps()
    # {:ok, opts} = cli_options(System.argv())
    # environment = Keyword.get(opts, :env, "d2")
    # service_group = Keyword.get(opts, :term, ["status: error"])

    body = %{
      query: "source:data-receiver AND env:d2",
      time: %{
        from: "2025-01-18T00:00:00Z",
        to: "2025-01-21T23:59:00Z"
      },
      limit: 1000,
      sort: "asc"
    }

    headers = [
      {"Content-Type", "application/json"},
      {"Accept", "application/json"},
      {"DD-API-KEY", "5f62e9a821973f43fadae5833cddbf8a"},
      {"DD-APPLICATION-KEY", "58e172870e85c248385b1bc53cfe9154617d8a14"}
    ]

    result =
      HTTPoison.post(
        "https://api.datadoghq.eu/api/v1/logs-queries/list",
        Poison.encode!(body),
        headers
      )

    IO.puts("#{inspect(result)}")
    # args = ["-n", namespace, "get", "pods", "-l", "app=" <> service_group]
  end

  defp ensure_deps() do
    Mix.install([
      {:httpoison, "~> 2.2.1"},
      {:poison, "~> 6.0"}
    ])
  end
end

DatadogLogs.main()

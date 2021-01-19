defmodule RetryMacro do
  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      use Retry
      import Stream
    end
  end

  defmacro retry_request(do: do_func) do
    # opts = Keyword.merge(@default_retry_options, opts)
    quote do
      retry with: constant_backoff(100) |> Stream.take(10), rescue_only: [MatchError] do
        # IO.puts "retrying macro"
        case unquote(do_func) do
          {:ok, %HTTPoison.Response{status_code: status_code}} when status_code >= 500 -> {:error, status_code}
          {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
          {:ok, resp} -> {:ok, resp}
        end
      after
        {:ok, response} ->
          # IO.puts "success"
          response
      else
        error ->
          # IO.puts "error"
          error
      end
    end
  end
end

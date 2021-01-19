defmodule RetryExample do
  use Retry
  use Retry.Annotation
  use RetryMacro

  @good_url "http://localhost:4200"
  @bad_url "http://localhost:4000"
  @not_found_url "http://localhost:4200/nope"

  def good_url, do: @good_url
  def bad_url, do: @bad_url
  def not_found_url, do: @not_found_url

  @doc """
  This uses the normal example from Retry's docs.
  """
  def call(url \\ @good_url) do
    retry with: constant_backoff(100) |> Stream.take(10), rescue_only: [MatchError] do
      case HTTPoison.get(url) do
        {:ok, %HTTPoison.Response{status_code: status_code}} when status_code >= 500 -> {:error, status_code}
        {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
        {:ok, resp} -> {:ok, resp}
      end
    after
      {:ok, response} ->
        response
    else
      error ->
        error
    end
  end

  @doc """
  This uses the annotation example from Retry's docs.
  """
  @retry with: constant_backoff(100) |> Stream.take(10)
  def annotated(url \\ @good_url), do: HTTPoison.get(url)

  @doc """
  This is the custom macro we wrote in RetryMacro using the same defaults as the other Retry implementations
  """
  def macro(url \\ @good_url) do
    RetryMacro.retry_request do: HTTPoison.get(url)
  end
end

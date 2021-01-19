Benchee.run(
  %{
    "macro" => fn url -> RetryExample.macro(url) end,
    "annotation" => fn url -> RetryExample.annotated(url) end,
    "regular" => fn url -> RetryExample.call(url) end
  },
  inputs: %{
    "good" => "http://localhost:4200",
    "bad" => "http://localhost:4000",
    "404" => "http://localhost:4200/nope"
  },
  memory_time: 2
)

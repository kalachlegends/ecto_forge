defmodule EctoForge do
  @cwd File.cwd!()
  @moduledoc File.read!(@cwd <> "/README.md")
end

defmodule EctoForge.Extension.Events.Logger.MacroLogger do
  @moduledoc """
  This macros for use `EctoForge.Extension.Events.Logger.DefaultLogger` more information in there module

  #example using
  ```elixir

  ## this module
  use Support.EctoForgeInstanceTest,
    extensions_events_additional: [
      define_log(TestModule, message: "artemka")
    ]

  ```
  """
  defmacro define_log(module, opts \\ []) do
    quote do
      opts_for_module = unquote(opts)

      defmodule unquote(module) do
        use(EctoForge.Extension.Events.Logger.DefaultLogger, opts_for_module)
      end

      unquote(module)
    end
  end
end

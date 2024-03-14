defmodule EctoForge.CreateInstance do
  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      @repo opts[:repo]
      @extensions_events opts[:extensions_events]
      @extensions_api opts[:extensions_api]
      @extensions_get opts[:extensions_get]

      defmacro __using__(opts_for_module) do
        quote location: :keep do
          opts_for_module =
            unquote(opts_for_module) |> IO.inspect(label: "lib/ecto_forge/create_instance.ex:10")

          ext =
            unquote(@extensions_events)
            |> IO.inspect(label: "lib/ecto_forge/create_instance.ex:13")

          use(
            EctoForge.DatabaseApi,
            [
              repo: unquote(@repo),
              extensions_api: unquote(@extensions_api),
              extensions_get: unquote(@extensions_get),
              extensions_events: unquote(@extensions_events)
            ] ++
              unquote(opts_for_module)
          )
        end
      end
    end
  end
end

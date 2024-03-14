defmodule Test.Event.ExtensionDeleteId do
  use EctoForge.CreateExtension.Events

  def after_get(result) do
    result |> Map.delete(:id)
  end

  def after_created({:ok, item}) do
    {:ok, item |> Map.delete(:id)}
  end
end

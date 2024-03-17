defmodule EctoForge.CreateExtension.Events do
  @moduledoc """

  ## !!!!! THIS MODULE IS DEVELOP,EXPEREMINTAL USING !!!!!!!!
  ## This module allows you to catch Events using callback functions.

  ## Using

  ### Create your callbacks with `EctoForge.CreateExtension.Events`
  ```elixir
  defmodule Test.Event.ExtensionDeleteId do
  use EctoForge.CreateExtension.Events

  def after_get(result) do
    result |> Map.delete(:password)
  end

  def after_created({:ok, item}) do
    {:ok, item |> Map.delete(:password)}
  end
  end
  ```
  ### Connect to your instansr or DataBaseApi

  ```elixir
  use EctoForge.CreateInstance,
    extensions_events: [MyApp.EctoForge.PasswordDeleter],
    repo: MyApp.Repo
  ```
  """
  @callback after_get(any()) :: any()
  @callback after_updated(any()) :: any()
  @callback after_deleted(any()) :: any()
  @callback after_created(any()) :: any()
  @callback after_deleted!(any()) :: any()
  @callback after_created!(any()) :: any()
  @callback after_updated!(any()) :: any()

  @callback before_updated(any()) :: any()
  @callback before_deleted(any()) :: any()
  @callback before_created(any()) :: any()
  @callback before_deleted!(any()) :: any()
  @callback before_created!(any()) :: any()
  @callback before_updated!(any()) :: any()
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @behaviour EctoForge.CreateExtension.Events

      def after_get(result) do
        result
      end

      def after_updated(result) do
        result
      end

      def after_deleted(result) do
        result
      end

      def after_created!(result) do
        result
      end

      def after_updated!(result) do
        result
      end

      def after_deleted!(result) do
        result
      end

      def after_created(result) do
        result
      end

      def before_updated(result) do
        result
      end

      def before_deleted(result) do
        result
      end

      def before_created(result) do
        result
      end

      def before_updated!(result) do
        result
      end

      def before_deleted!(result) do
        result
      end

      def before_created!(result) do
        result
      end

      defoverridable after_get: 1
      defoverridable after_updated: 1
      defoverridable after_deleted: 1
      defoverridable after_created: 1

      defoverridable after_created!: 1
      defoverridable after_deleted!: 1
      defoverridable after_updated!: 1

      defoverridable before_updated: 1
      defoverridable before_deleted: 1
      defoverridable before_created: 1

      defoverridable before_created!: 1
      defoverridable before_deleted!: 1
      defoverridable before_updated!: 1
    end
  end
end

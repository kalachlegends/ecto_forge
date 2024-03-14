defmodule EctoForge.CreateExtension.Events do
  @moduledoc """

  """

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
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

      def before_get(result) do
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

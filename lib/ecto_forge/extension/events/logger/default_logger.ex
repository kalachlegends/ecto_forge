defmodule EctoForge.Extension.Events.Logger.DefaultLogger do
  @moduledoc """


  ### use in define module
  ```elixir
  defmodule SomethingLogger do
    use EctoForge.Extension.Events.Logger.DefaultLogger, is_result_log: true, is_event_log: true, message: "somemessage"
  end
  ```
  ### after connect to your Module
  ```elixir
  use Support.EctoForgeInstanceTest,
    extensions_events_additional: [
      define_log(SomethingLogger, message: "artemka")
    ]

  ```

  ## paramets
  - only_events: :all, :after -> this filter by events
  - is_result_log: result function to your logs
  -
  - message: to emmebed to you logger
  """
  defmacro __using__(opts) do
    require Logger

    quote location: :keep, bind_quoted: [opts: opts] do
      @message opts[:message] || ""
      require Logger

      @is_result_log if(is_boolean(opts[:is_result_log]), do: opts[:is_result_log], else: true)
      @is_event_log if(is_boolean(opts[:is_event_log]),
                      do: opts[:is_event_log],
                      else: true
                    )
      @only_events opts[:only_events] || :all

      use EctoForge.CreateExtension.Events

      def log(
            function,
            result
          ) do
        cond do
          @only_events == :all ->
            log(function, result, "#{@message}", %{
              message: @message,
              is_result_log: @is_result_log,
              is_event_log: @is_event_log
            })

          is_atom(@only_events) ->
            if String.match?(Atom.to_string(function), ~r/#{Atom.to_string(@only_events)}/) do
              log(function, result, "#{@message}", %{
                is_result_log: @is_result_log,
                is_event_log: @is_event_log
              })
            else
              result
            end

          function in @only_events ->
            log(function, result, "#{@message}", %{
              is_result_log: @is_result_log,
              is_event_log: @is_event_log
            })

          true ->
            result
        end
      end

      def log(function, result, acc_log, %{is_event_log: true} = acc) do
        log(
          function,
          result,
          "#{acc_log} event: #{function},",
          Map.delete(acc, :is_event_log)
        )
      end

      def log(function, result, acc_log, %{is_result_log: true} = acc) do
        log(
          function,
          result,
          "#{acc_log} result: #{inspect(result, pretty: true)}",
          Map.delete(acc, :is_result_log)
        )
      end

      def log(function, result, acc_log, _) do
        Logger.info(acc_log)
        result
      end

      def after_get(result) do
        log(:after_get, result)
      end

      def after_updated(result) do
        log(:after_updated, result)
      end

      def after_deleted(result) do
        log(:after_deleted, result)
      end

      def after_created!(result) do
        log(:after_created!, result)
      end

      def after_updated!(result) do
        log(:after_updated!, result)
      end

      def after_deleted!(result) do
        log(:after_deleted!, result)
      end

      def after_created(result) do
        log(:after_created, result)
      end

      def before_updated(result) do
        log(:before_updated, result)
      end

      def before_deleted(result) do
        log(:before_deleted, result)
      end

      def before_created(result) do
        log(:before_created, result)
      end

      def before_updated!(result) do
        log(:before_updated!, result)
      end

      def before_deleted!(result) do
        log(:before_deleted!, result)
      end

      def before_created!(result) do
        log(:before_created!, result)
      end
    end
  end
end

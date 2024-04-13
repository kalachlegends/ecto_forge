defmodule EctoForge.Extension.Default do
  @moduledoc """
  Default extension for ecto_forge
  """
  @doc """
  all extenision by ecto forge
  """
  @spec all_list_extensions_get() :: [
          EctoForge.Extension.Get.FilterError
          | EctoForge.Extension.Get.Aggregate
          | EctoForge.Extension.Get.Filter
          | EctoForge.Extension.Get.Last
          | EctoForge.Extension.Get.Limit
          | EctoForge.Extension.Get.OnlyQuery
          | EctoForge.Extension.Get.OrderBy
          | EctoForge.Extension.Get.Pagination
          | EctoForge.Extension.Get.Preload
          | EctoForge.Extension.Get.QueryFunction
          | EctoForge.Extension.Get.Select,
          ...
        ]
  def all_list_extensions_get() do
    [
      EctoForge.Extension.Get.FilterError,
      EctoForge.Extension.Get.Filter,
      EctoForge.Extension.Get.Preload,
      EctoForge.Extension.Get.Last,
      EctoForge.Extension.Get.Limit,
      EctoForge.Extension.Get.OrderBy,
      EctoForge.Extension.Get.Aggregate,
      EctoForge.Extension.Get.OnlyQuery,
      EctoForge.Extension.Get.Select,
      EctoForge.Extension.Get.Pagination,
      EctoForge.Extension.Get.QueryFunction
    ]
  end

  @doc """
    all extenision by ecto forge without  EctoForge.Extension.Get.FilterError,
  """
  @spec all_list_extensions_get_without_filter_error() :: [
          EctoForge.Extension.Get.Aggregate
          | EctoForge.Extension.Get.Filter
          | EctoForge.Extension.Get.Last
          | EctoForge.Extension.Get.Limit
          | EctoForge.Extension.Get.OnlyQuery
          | EctoForge.Extension.Get.OrderBy
          | EctoForge.Extension.Get.Pagination
          | EctoForge.Extension.Get.Preload
          | EctoForge.Extension.Get.QueryFunction
          | EctoForge.Extension.Get.Select,
          ...
        ]
  def all_list_extensions_get_without_filter_error() do
    [
      EctoForge.Extension.Get.Filter,
      EctoForge.Extension.Get.Preload,
      EctoForge.Extension.Get.Last,
      EctoForge.Extension.Get.Limit,
      EctoForge.Extension.Get.OrderBy,
      EctoForge.Extension.Get.Aggregate,
      EctoForge.Extension.Get.OnlyQuery,
      EctoForge.Extension.Get.Select,
      EctoForge.Extension.Get.Pagination,
      EctoForge.Extension.Get.QueryFunction
    ]
  end
end

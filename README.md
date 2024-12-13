# EctoForge

## Motivation

This library allows on-the-go editing of contexts, extensions, and providing basic work for the database with ecto.

With this library you can add your own extensions for functions such as `find_all` `get_all` `get!` `find`

In addition to generation and creation, this library implements standardised functions such as update!() create() delete().
More about it here `EctoForge.DatabaseApi` or https://hexdocs.pm/ecto_forge/EctoForge.DatabaseApi.html

![image](https://github.com/user-attachments/assets/6e87e274-432e-4ff9-a42b-4ebdf4306ef8)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ecto_forge` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_forge, "~>  0.1.22"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/ecto_forge>.

## Create an instance and plug in the necessary extensions from the existing ones or use ready-made ones

by default all extensions are used `EctoForge.Extension.Default.all_list_extensions_get()`

```elixir
defmodule MyApp.EctoForgeInstanseBase do
  use EctoForge.CreateInstance,
    repo: MyApp.Repo
end
```

### if you want customize your extension you can rewrite

```elixir
defmodule MyApp.EctoForgeInstanseBase do
  use EctoForge.CreateInstance,
    extensions_events: [],
    extensions_get: [
        EctoForge.Extension.Get.Preload,
        EctoForge.Extension.Get.Filter,
        EctoForge.Extension.Get.Last,
        EctoForge.Extension.Get.Limit,
        EctoForge.Extension.Get.OrderBy,
        EctoForge.Extension.Get.Aggregate,
        EctoForge.Extension.Get.Select,
        EctoForge.Extension.Get.Pagination,
        EctoForge.Extension.Get.OnlyQuery,
        EctoForge.Extension.Get.QueryFunction
    ],
    repo: MyApp.Repo
end
```

### After you can use api `EctoForge.DatabaseApi`

You will then be able to connect your instance to the model or reuse it in context

```elixir

 defmodule MyApp.UserModel do
  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  schema "user" do
    field(:name, :string)
  end

  use MyApp.EctoForgeInstanseBase
  @doc false
  def changeset(emails_model \\ %__MODULE__{}, attrs) do
    emails_model
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
```

After connection, the basic functions such as 'update', 'create', 'delete' for the model will appear in the module `MyApp.UserModel`

### Or create your own context

```elixir
defmodule MyApp.Context.UserModel do
 use MyApp.EctoForgeInstanseBase, module_model: MyApp.UserModel
end
```

## What are extensions?

This is the basic control for the `find` `find_all` `get_all` `get!` `get_all`

### More information in module `EctoForge.CreateExtension.Get`

More information `EctoForge.CreateExtension.Get`

### Extensions in action

You can use callback functions for processing. After the query and before the query to filter the data.

```elixir
 @doc """
 module MyApp.UserModel -> your own module
 mode -> :all or :one
 query -> handled query
 repo -> MyApp.Repo
 list_exetensions_executed -> Executed list of extensions
 attrs -> attributes that fall
 """
  def before_query_add_extension_to_get(_module, _mode, _repo _list_exetensions_executed, query, attrs) do
    {query, attrs} # must return query and modified attributes
  end
   @doc """
    module MyApp.UserModel -> your own module
    query -> handled query
    _list_exetensions_executed -> Executed list of extensions
    attrs -> attributes that fall
    prev_query-> prev_query before pipline
 """
  def after_query_add_extension_to_get(module, mode, repo, _list_exetensions_executed prev_query, result, attrs) do
    {prev_query,result, attrs} # must return result and modified attributes
  end
```

create your first extension using the module.

#### Example

```elixir
defmodule EctoForge.Extension.Get.Preload do
  @moduledoc """
  ## Use preload with your model
  ### Example
  MyApp.UserModel.find(preload: [:posts])
  """
  alias EctoForge.Helpers.RepoBase.Utls
  import Ecto.Query
  use EctoForge.CreateExtension.Get

  def before_query_add_extension_to_get(_module, _mode, _repo, query, attrs) do
    preload_attrs = Utls.MapUtls.opts_to_map(attrs)
    attrs = Keyword.delete(attrs, :preload)

    if is_list(preload_attrs) do
      {preload(query, ^preload_attrs), attrs}
    else
      {query, attrs}
    end
  end
end
```

## List extensions by `EctoForge.Extension.Default.all_list_extensions_get()`

- `EctoForge.Extension.Get.Preload`
- `EctoForge.Extension.Get.Last`
- `EctoForge.Extension.Get.Limit`
- `EctoForge.Extension.Get.Aggregate`
- `EctoForge.Extension.Get.OrderBy`
- `EctoForge.Extension.Get.Filter`
- `EctoForge.Extension.Get.Lock`
- `EctoForge.Extension.Get.OnlyQuery`


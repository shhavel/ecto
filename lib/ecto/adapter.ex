defmodule Ecto.Adapter do
  @moduledoc """
  This module specifies the adapter API that an adapter is required to
  implement.
  """

  use Behaviour

  @type t :: module
  @type source :: binary
  @type fields :: Keyword.t
  @type filters :: Keyword.t
  @type returning :: [atom]
  @type autogenerate_id :: {field :: atom, type :: :id | :binary_id, value :: term} | nil

  @typep repo :: Ecto.Repo.t
  @typep options :: Keyword.t

  @doc """
  The callback invoked in case the adapter needs to inject code.
  """
  defmacrocallback __before_compile__(Macro.Env.t) :: Macro.t

  @doc """
  Starts any connection pooling or supervision and return `{:ok, pid}`
  or just `:ok` if nothing needs to be done.

  Returns `{:error, {:already_started, pid}}` if the repo already
  started or `{:error, term}` in case anything else goes wrong.
  """
  defcallback start_link(repo, options) ::
              {:ok, pid} | :ok | {:error, {:already_started, pid}} | {:error, term}

  @doc """
  Stops any connection pooling or supervision started with `start_link/1`.
  """
  defcallback stop(repo) :: :ok

  @doc """
  Fetches all results from the data store based on the given query.
  """
  defcallback all(repo, query :: Ecto.Query.t, params :: list(), options) :: [[term]] | no_return

  @doc """
  Updates all entities matching the given query with the values given. The
  query shall only have `where` expressions and a single `from` expression. Returns
  the number of affected entities.
  """
  defcallback update_all(repo, query :: Ecto.Query.t,
                         updates :: Keyword.t, params :: list(),
                         options) :: integer | no_return

  @doc """
  Deletes all entities matching the given query.

  The query shall only have `where` expressions and a `from` expression.
  Returns the number of affected entities.
  """
  defcallback delete_all(repo, query :: Ecto.Query.t,
                         params :: list(), options :: Keyword.t) :: integer | no_return

  @doc """
  Inserts a single new model in the data store.
  """
  defcallback insert(repo, source, fields, autogenerate_id, returning, options) ::
                    {:ok, Keyword.t} | no_return

  @doc """
  Updates a single model with the given filters.

  While `filters` can be any record column, it is expected that
  at least the primary key (or any other key that uniquely
  identifies an existing record) to be given as filter. Therefore,
  in case there is no record matching the given filters,
  `{:error, :stale}` is returned.
  """
  defcallback update(repo, source, fields, filters, returning, options) ::
                    {:ok, Keyword.t} | {:error, :stale} | no_return

  @doc """
  Deletes a sigle model with the given filters.

  While `filters` can be any record column, it is expected that
  at least the primary key (or any other key that uniquely
  identifies an existing record) to be given as filter. Therefore,
  in case there is no record matching the given filters,
  `{:error, :stale}` is returned.
  """
  defcallback delete(repo, source, filters, options) ::
                     {:ok, Keyword.t} | {:error, :stale} | no_return
end

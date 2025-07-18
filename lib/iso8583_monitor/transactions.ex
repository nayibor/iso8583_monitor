defmodule Iso8583Monitor.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Iso8583Monitor.Repo

  alias Iso8583Monitor.Transactions.Rule
  alias Iso8583Monitor.Utils
  
  @doc """
  Returns the list of rules.

  ## Examples

      iex> list_rules()
      [%Rule{}, ...]

  """
  def list_rules(params \\ %{name: "",limit: Utils.get_page_size(),offset: Utils.get_offset(1)}) do
    limit = params.limit
    offset = params.offset
    name = params.name
    search_string = "%#{name}%" 
    Repo.all(from r in Rule,limit: ^limit,offset: ^offset,order_by: [desc: :id],where:  ilike(field(r,:name), ^search_string))    
  end
  
  # def list_rules do
  #   Repo.all(Rule)
  # end

  @doc """
  Gets a single rule.

  Raises `Ecto.NoResultsError` if the Rule does not exist.

  ## Examples

      iex> get_rule!(123)
      %Rule{}

      iex> get_rule!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rule!(id), do: Repo.get!(Rule, id)

  @doc """
  Creates a rule.

  ## Examples

      iex> create_rule(%{field: value})
      {:ok, %Rule{}}

      iex> create_rule(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rule(attrs \\ %{}) do
    %Rule{}
    |> Rule.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rule.

  ## Examples

      iex> update_rule(rule, %{field: new_value})
      {:ok, %Rule{}}

      iex> update_rule(rule, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rule(%Rule{} = rule, attrs) do
    rule
    |> Rule.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a rule.

  ## Examples

      iex> delete_rule(rule)
      {:ok, %Rule{}}

      iex> delete_rule(rule)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rule(%Rule{} = rule) do
    Repo.delete(rule)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rule changes.

  ## Examples

      iex> change_rule(rule)
      %Ecto.Changeset{data: %Rule{}}

  """
  def change_rule(%Rule{} = rule, attrs \\ %{}) do
    Rule.changeset(rule, attrs)
  end
end

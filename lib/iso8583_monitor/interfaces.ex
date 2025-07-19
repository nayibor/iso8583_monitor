defmodule Iso8583Monitor.Interfaces do
  @moduledoc """
  The Interfaces context.
  """

  import Ecto.Query, warn: false
  alias Iso8583Monitor.Repo

  alias Iso8583Monitor.Interfaces.Interface

  @doc """
  Returns the list of interfaces.

  ## Examples

      iex> list_interfaces()
      [%Interface{}, ...]

  """
  def list_interfaces do
    Repo.all(Interface)
  end

  @doc """
  Gets a single interface.

  Raises `Ecto.NoResultsError` if the Interface does not exist.

  ## Examples

      iex> get_interface!(123)
      %Interface{}

      iex> get_interface!(456)
      ** (Ecto.NoResultsError)

  """
  def get_interface!(id), do: Repo.get!(Interface, id)

  @doc """
  Creates a interface.

  ## Examples

      iex> create_interface(%{field: value})
      {:ok, %Interface{}}

      iex> create_interface(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_interface(attrs \\ %{}) do
    %Interface{}
    |> Interface.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a interface.

  ## Examples

      iex> update_interface(interface, %{field: new_value})
      {:ok, %Interface{}}

      iex> update_interface(interface, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_interface(%Interface{} = interface, attrs) do
    interface
    |> Interface.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a interface.

  ## Examples

      iex> delete_interface(interface)
      {:ok, %Interface{}}

      iex> delete_interface(interface)
      {:error, %Ecto.Changeset{}}

  """
  def delete_interface(%Interface{} = interface) do
    Repo.delete(interface)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking interface changes.

  ## Examples

      iex> change_interface(interface)
      %Ecto.Changeset{data: %Interface{}}

  """
  def change_interface(%Interface{} = interface, attrs \\ %{}) do
    Interface.changeset(interface, attrs)
  end
end

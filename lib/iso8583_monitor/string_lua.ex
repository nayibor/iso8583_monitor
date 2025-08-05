defmodule Iso8583Monitor.StringLua do

  @moduledoc """  
  A custom Ecto type for handling the parsing of lua strings
  """
  use Ecto.Type
  def type, do: :string

  @doc """
  Provides custom casting rules for params. Nothing changes here.
  We only need to handle checking if term is valid lua term.
  """
  def cast(term) when is_binary(term) do
    case :luerl.load(term,:luerl.init()) do
	{:ok,_,_} -> {:ok,term}
	{:error,_,_} -> :error
    end
  end
  
  def cast(_), do: :error 
    
  @doc """
  Convert the lua string from the database
  """
  def load(lua_string) do
    {:ok,lua_string}
  end
  @doc """
  Converting the data structure to database format.
  """
  def dump(lua_string) do
    {:ok,lua_string}
  end
end

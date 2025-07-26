defmodule Iso8583Monitor.StringMap do
  @moduledoc """  
  A custom Ecto type for handling the serialization of strings
  which contain map data in the database. 
  """
  use Ecto.Type
  def type, do: :map

  @doc """
  Provides custom casting rules for params. Nothing changes here.
  We only need to handle deserialization.
  """
  def cast(term) when is_binary(term) do
    case Jason.decode(term) do
     {:ok,decoded_term} when is_map(decoded_term) -> {:ok,term}
     _ -> :error		
    end
  end
  
  def cast(_), do: :error 
    
  @doc """
  Convert the raw map value from the database back to a string.
  """
  def load(raw_map) when is_map(raw_map),
    do: Jason.encode(raw_map)

  @doc """
  Converting the data structure to map for storage.
  """
  def dump(term) do
    Jason.decode(term)
  end
end

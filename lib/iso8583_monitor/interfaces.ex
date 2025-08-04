defmodule Iso8583Monitor.Interfaces do
  @moduledoc """
  The Interfaces context.
  """

  import Ecto.Query, warn: false
  alias Iso8583Monitor.Repo
  alias Iso8583Monitor.Interfaces.Interface
  alias Iso8583Monitor.Transactions.Rule
  alias Iso8583Monitor.Utils
  require Logger


  @doc """
  this is for converting an iso string spec into a format which can be
  used by iso8583_erl library
  """
  def convert_spec(spec_string) do
    case Jason.decode(spec_string) do
      {:ok,decoded_string} ->
	Enum.map(decoded_string,
	  fn {key,value} ->
	    case key do
	      "bitmap_type" -> {:bitmap_type,bitmap_type(value)}
	      field_number  ->
		{String.to_integer(field_number),
		 %{
		   pad_info: {pad_direction(value["pad_info"]["direction"]),pad_char(value["pad_info"]["char"])},
		   length_field: value["length_field"],
		   header_length: value["header_length"],
		   sub_format: String.to_charlist(value["sub_format"])
		   ##type: value["type"]
		 }
		}
	    end
	end)
	error -> error
    end
  end

  def bitmap_type("bitmap"), do: :bitmap
  def bitmap_type("hex"), do: :hex
	
  def pad_direction("none"), do: :none
  def pad_direction("left"), do: :left
  def pad_direction("right"), do: :right

  def pad_char("none"), do: :none
  def pad_char(char), do: char 

  
  def start_interface(interface) do
    specification_decoded = convert_spec(interface.specification)
    specification = :iso8583_erl.load_specification_using_data(specification_decoded)
    resp = :ranch.start_listener(interface.pool_name,:ranch_tcp,%{socket_opts: [{:port,interface.port}],max_connections: interface.max_connections},:iso_sock_server,[interface.header_size,specification])
    case resp do
      {:ok,_ } ->
	update_interface(interface,%{id: interface.id,status: :true})
	Logger.info("interface #{interface.name} started succesfully")
      {:error,term } -> Logger.error(term )    
    end
  end


  def start_interfaces() do
    Logger.info("**starting interface servers**")
    interfaces = list_interfaces()
    Enum.map(interfaces,fn interface -> start_interface(interface) end)
  end  
  
  def stop_interface(interface) do
    resp = :ranch.stop_listener(interface.pool_name)
    case resp do
      :ok ->
	update_interface(interface,%{id: interface.id,status: false})
	Logger.info("interface #{interface.name} stopped succesfully")
      {:error,_} -> Logger.error("interface not found")		
    end
  end

  def stop_interfaces() do
    Logger.info("**stopping interface servers**")
    interfaces = list_interfaces()
    Enum.map(interfaces,fn interface -> stop_interface(interface) end)
  end


  def test_trasaction(transaction_map) do
     interfaces = Repo.all_by(Interface, status: :true,pool_type: :server)
    case length(interfaces) do
      size_length when size_length > 0 ->
	interface = Enum.at(interfaces,0)
	specification_decoded = convert_spec(interface.specification)
	specification = :iso8583_erl.load_specification_using_data(specification_decoded)
	iso_message = :iso8583_erl.pack(transaction_map,specification)
	final_size = :iso8583_erl.get_size_send(iso_message,interface.header_size)
	final_socket_send = [final_size,iso_message]
	Logger.info("**sending test transaction**")	
	:io.format("~n message map  sent is ~p",[transaction_map])	 
	case :gen_tcp.connect(String.to_charlist(interface.address), interface.port, [:list, {:active, :once}]) do
	  {:ok, socket} ->
	    :ok = :gen_tcp.send(socket,final_socket_send)
	    :ok = :gen_tcp.close(socket)
	  {:error, error} -> Logger.error(error)
	end
      _ -> Logger.info("no active interface servers available")
    end
  end

  
  def load_rules() do
    rules = Repo.all_by(Rule, status: :true)
    case Enum.member?(:ets.all(),:rules) do
      :true -> Enum.map(rules,fn rule -> :ets.insert(:rules,{rule.id,rule.expression,rule.tag}) end)
      :false ->
	rule_table = :ets.new(:rules, [:set,:named_table])
	Enum.map(rules,fn rule -> :ets.insert(rule_table,{rule.id,rule.expression,rule.tag}) end)
    end
  end

  
  @doc """
  Returns the list of interfaces.

  ## Examples

      iex> list_interfaces()
      [%Interface{}, ...]

  """
  def list_interfaces(params \\ %{name: "",limit: Utils.get_page_size(),offset: Utils.get_offset(1)}) do
    limit = params.limit
    offset = params.offset
    name = params.name
    search_string = "%#{name}%" 
    Repo.all(from r in Interface,limit: ^limit,offset: ^offset,order_by: [desc: :id],where:  ilike(field(r,:name), ^search_string))    
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

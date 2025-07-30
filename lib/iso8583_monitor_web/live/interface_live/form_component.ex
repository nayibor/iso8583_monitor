defmodule Iso8583MonitorWeb.InterfaceLive.FormComponent do
  use Iso8583MonitorWeb, :live_component

  alias Iso8583Monitor.Interfaces

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage interface records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="interface-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:pool_name]} type="text" label="Pool name" />
        <.input field={@form[:address]} type="text" label="Address" />
        <.input field={@form[:port]} type="number" label="Port" />
         <.input field={@form[:specification]} type="textarea" label="Specification" />   
        <.input
          field={@form[:pool_type]}
          type="select"
          label="Pool type"
          prompt="Choose a value"
          options={Ecto.Enum.values(Iso8583Monitor.Interfaces.Interface, :pool_type)}
        />
        <.input field={@form[:header_size]} type="number" label="Header Size" />
        <.input field={@form[:max_connections]} type="number" label="Maximum Connections" />	
        <.input field={@form[:status]} type="checkbox" label="Status" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Interface</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{interface: interface} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Interfaces.change_interface(interface))
     end)}
  end

  @impl true
  def handle_event("validate", %{"interface" => interface_params}, socket) do
    changeset = Interfaces.change_interface(socket.assigns.interface, interface_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"interface" => interface_params}, socket) do
    save_interface(socket, socket.assigns.action, interface_params)
  end

  defp save_interface(socket, :edit, interface_params) do
    case Interfaces.update_interface(socket.assigns.interface, interface_params) do
      {:ok, interface} ->
        notify_parent({:saved, interface})

        {:noreply,
         socket
         |> put_flash(:info, "Interface updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_interface(socket, :new, interface_params) do
    case Interfaces.create_interface(interface_params) do
      {:ok, interface} ->
        notify_parent({:saved, interface})

        {:noreply,
         socket
         |> put_flash(:info, "Interface created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

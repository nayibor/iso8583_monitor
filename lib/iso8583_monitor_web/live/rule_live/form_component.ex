defmodule Iso8583MonitorWeb.RuleLive.FormComponent do
  use Iso8583MonitorWeb, :live_component

  alias Iso8583Monitor.Transactions

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage rule records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="rule-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:expression]} type="textarea" label="Expression" />
        <.input field={@form[:tag]} type="text" label="Tag" />
        <.input field={@form[:status]} type="checkbox" label="Status" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Rule</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{rule: rule} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Transactions.change_rule(rule))
     end)}
  end

  @impl true
  def handle_event("validate", %{"rule" => rule_params}, socket) do
    changeset = Transactions.change_rule(socket.assigns.rule, rule_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"rule" => rule_params}, socket) do
    save_rule(socket, socket.assigns.action, rule_params)
  end

  defp save_rule(socket, :edit, rule_params) do
    case Transactions.update_rule(socket.assigns.rule, rule_params) do
      {:ok, rule} ->
        notify_parent({:saved, rule})

        {:noreply,
         socket
         |> put_flash(:info, "Rule updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_rule(socket, :new, rule_params) do
    case Transactions.create_rule(rule_params) do
      {:ok, rule} ->
        notify_parent({:saved, rule})

        {:noreply,
         socket
         |> put_flash(:info, "Rule created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

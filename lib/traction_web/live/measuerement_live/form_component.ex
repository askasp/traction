defmodule TractionWeb.MeasuerementLive.FormComponent do
  use TractionWeb, :live_component

  alias Traction.Discord

  @impl true
  def update(%{measuerement: measuerement} = assigns, socket) do
    changeset = Discord.change_measuerement(measuerement)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"measuerement" => measuerement_params}, socket) do
    changeset =
      socket.assigns.measuerement
      |> Discord.change_measuerement(measuerement_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"measuerement" => measuerement_params}, socket) do
    save_measuerement(socket, socket.assigns.action, measuerement_params)
  end

  defp save_measuerement(socket, :edit, measuerement_params) do
    case Discord.update_measuerement(socket.assigns.measuerement, measuerement_params) do
      {:ok, _measuerement} ->
        {:noreply,
         socket
         |> put_flash(:info, "Measuerement updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_measuerement(socket, :new, measuerement_params) do
    case Discord.create_measuerement(measuerement_params) do
      {:ok, _measuerement} ->
        {:noreply,
         socket
         |> put_flash(:info, "Measuerement created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

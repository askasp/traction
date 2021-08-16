defmodule TractionWeb.MeasuerementLive.Index do
  use TractionWeb, :live_view

  alias Traction.Discord
  alias Traction.Discord.Measuerement

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :measurements, list_measurements())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Measuerement")
    |> assign(:measuerement, Discord.get_measuerement!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Measuerement")
    |> assign(:measuerement, %Measuerement{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Measurements")
    |> assign(:measuerement, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    measuerement = Discord.get_measuerement!(id)
    {:ok, _} = Discord.delete_measuerement(measuerement)

    {:noreply, assign(socket, :measurements, list_measurements())}
  end

  defp list_measurements do
    Discord.list_measurements()
  end
end

defmodule TractionWeb.GuildLive.FormComponent do
  use TractionWeb, :live_component

  alias Traction.Discord

  @impl true
  def update(%{guild: guild} = assigns, socket) do
    changeset = Discord.change_guild(guild)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"guild" => guild_params}, socket) do
    changeset =
      socket.assigns.guild
      |> Discord.change_guild(guild_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"guild" => guild_params}, socket) do
    save_guild(socket, socket.assigns.action, guild_params)
  end

  defp save_guild(socket, :edit, guild_params) do
    case Discord.update_guild(socket.assigns.guild, guild_params) do
      {:ok, _guild} ->
        {:noreply,
         socket
         |> put_flash(:info, "Guild updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_guild(socket, :new, guild_params) do
    case Discord.create_guild(guild_params) do
      {:ok, _guild} ->
        {:noreply,
         socket
         |> put_flash(:info, "Guild created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

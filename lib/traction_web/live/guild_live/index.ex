defmodule TractionWeb.GuildLive.Index do
  use TractionWeb, :live_view

  alias Traction.Discord
  alias Traction.Discord.Guild

  @impl true
  def mount(_params, _session, socket) do
    guilds = Enum.map(list_guilds(), fn guild -> add_chart_to_guild(guild) end)

    :ok = Phoenix.PubSub.subscribe(Traction.PubSub, "new_measuerments")

    {:ok, assign(socket, :guilds, guilds)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_info(:new_measurements, socket) do
    guilds = Enum.map(list_guilds(), fn guild -> add_chart_to_guild(guild) end)
    {:noreply, assign(socket, :guilds, guilds)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Guild")
    |> assign(:guild, Discord.get_guild!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Guild")
    |> assign(:guild, %Guild{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Guilds")
    |> assign(:guild, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    guild = Discord.get_guild!(id)
    {:ok, _} = Discord.delete_guild(guild)

    {:noreply, assign(socket, :guilds, list_guilds())}
  end

  defp list_guilds do
    Discord.list_guilds()
  end

  defp add_chart_to_guild(guild) do
    guild = Traction.Repo.preload(guild, :measurements)
    data = Enum.map(guild.measurements, fn m -> {m.inserted_at, m.total, m.online} end)

    case data do
      [] ->
        Map.put(guild, :svg, "")

      x ->
        ds = Contex.Dataset.new(data, ["Time", "Total", "Online"])

        myplot =
          Contex.Plot.new(ds, Contex.LinePlot, 600, 400,
            mapping: %{x_col: "Time", y_cols: ["Total", "Online"]}
          )
          |> Contex.Plot.plot_options(%{legend_setting: :legend_right})
          |> Contex.Plot.titles(guild.guild_name, "Added by: " <> guild.added_by)

        Map.put(guild, :svg, Contex.Plot.to_svg(myplot))
    end
  end
end

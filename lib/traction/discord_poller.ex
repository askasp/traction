defmodule Traction.DiscordPoller do
  use GenServer
  @auth_key Application.get_env(:traction, :discord_key)

  def start_link(_), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def poll_discord() do
    GenServer.call(__MODULE__, :poll_discord)
  end

  def init(_) do
    send(self(), :poll_discord)
    {:ok, %{}}
  end

  def handle_call(:poll_discord, _from, state) do
    send(self(), :poll_discord)
    send(self(), :poll_discord)
    {:reply, :ok, state}
  end

  def handle_info(:poll_discord, guilds) do
    guilds = Traction.Repo.all(Traction.Discord.Guild)

    Enum.map(guilds, fn guild ->
      resp =
        Finch.build(
          :get,
          "https://discord.com/api/v9/guilds/#{guild.guild_id}?with_counts=true",
          [{"authorization", @auth_key}]
        )
        |> Finch.request(MyFinch)

      case resp do
        {:ok, result} ->
          data = result.body |> Jason.decode!()
          IO.puts("got result from disdocrd")

          measuremet =
            Ecto.build_assoc(guild, :measurements, %{
              online: data["approximate_presence_count"],
              total: data["approximate_member_count"]
            })

          Traction.Repo.insert(measuremet)

        x ->
          IO.puts("got error")
          IO.inspect(x)
      end
    end)

    :ok = Phoenix.PubSub.broadcast(Traction.PubSub, "new_measuerments", :new_measurements)

    Process.send_after(self(), :poll_discord, 3_600_000)

    {:noreply, %{}}
  end
end

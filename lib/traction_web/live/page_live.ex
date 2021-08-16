defmodule TractionWeb.PageLive do
  use TractionWeb, :live_view
  require Logger
  alias Contex.{Dataset, LinePlot, Plot}

  @impl true
  def mount(_params, _session, socket) do
    # data = [{1, 1}, {2, 2}]
    # ds = Dataset.new(data, ["x", "y"])

    ds = Dataset.new([{1, 2, 3}, {2, 4, 8}], ["time", "Total", "Online"])

    IO.inspect(ds)
    IO.inspect(Dataset.column_names(ds))
    sammad = LinePlot.new(ds)

    # myplot = Plot.new(600, 400, sammad) |> Plot.plot_options(%{legend_setting: :legend_right})
    myplot =
      Plot.new(ds, Contex.LinePlot, 600, 400,
        mapping: %{x_col: "time", y_cols: ["Total", "Online"]}
      )
      |> Plot.plot_options(%{legend_setting: :legend_right})
      |> Plot.titles("pudgy penguin", "sub title")

    # point_plot = Contex.PointPlot.new(ds)
    # my_svg = Contex.Plot.to_svg(point_plot)
    #

    {:ok, assign(socket, query: "", results: %{}, my_svg: Plot.to_svg(myplot))}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: search(query), query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      %{^query => vsn} ->
        {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "No dependencies found matching \"#{query}\"")
         |> assign(results: %{}, query: query)}
    end
  end

  defp search(query) do
    if not TractionWeb.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end
end

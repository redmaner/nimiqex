defmodule Nimiqex do
  require Logger
  use GenServer

  defp default_opts do
    [
      name: :default,
      url: "http://seed1.nimiq.local:8648",
      use_auth: false,
      username: "",
      password: "",
      protocol: :http2,
      connections: System.schedulers_online()
    ]
  end

  def start_link(opts) do
    name = default_opts() |> Keyword.merge(opts) |> Keyword.fetch!(:name)
    GenServer.start_link(__MODULE__, opts, name: :"#{__MODULE__}.#{name}")
  end

  def init(opts) do
    with opts <- default_opts() |> Keyword.merge(opts),
         {:ok, name} <- opts |> Keyword.fetch(:name),
         {:ok, url} <- opts |> Keyword.fetch(:url),
         {:ok, use_auth} <- opts |> Keyword.fetch(:use_auth),
         {:ok, username} <- opts |> Keyword.fetch(:username),
         {:ok, password} <- opts |> Keyword.fetch(:password),
         {:ok, protocol} <- opts |> Keyword.fetch(:protocol),
         {:ok, connections} <- opts |> Keyword.fetch(:connections),
         http_pool <- new_http_pool(url, protocol, connections),
         {:ok, pid} <- Jsonrpc.start_link(name: name, pool: http_pool) do
      state = %{
        finch: pid,
        name: name,
        url: url,
        use_auth: use_auth,
        username: username,
        password: password
      }

      {:ok, state}
    else
      error ->
        raise "Starting Nimiq RPC client failed: #{inspect(error, pretty: true)}"
    end
  end

  defp new_http_pool(url, protocol, connections) do
    %{
      :default => [
        size: 50,
        count: connections
      ]
    }
    |> Map.put(url,
      size: 50,
      count: connections,
      protocol: protocol
    )
  end

  def send(request, name \\ :default) do
    GenServer.call(:"#{__MODULE__}.#{name}", {:send_rpc, &Jsonrpc.call/2, request}, 60_000)
  end

  def send!(request, name \\ :default) do
    GenServer.call(:"#{__MODULE__}.#{name}", {:send_rpc, &Jsonrpc.call!/2, request}, 60_000)
  end

  def handle_call({:send_rpc, jsonrpc_func, request}, _from, state = %{name: name, url: url}) do
    headers = create_headers(state)

    return =
      request
      |> jsonrpc_func.(name: name, url: url, headers: headers)

    {:reply, return, state}
  end

  defp create_headers(_state = %{password: password, username: username, use_auth: true}) do
    auth = Base.encode64(username <> ":" <> password)
    [{"Content-Type", "application/json"}, {"Authorization", "Basic " <> auth}]
  end

  defp create_headers(_state) do
    [{"Content-Type", "application/json"}]
  end

  @doc false
  defmacro rpc(func_name, opts) when is_atom(func_name) and is_list(opts) do
    opts =
      [
        method: "",
        description: "",
        params: []
      ]
      |> Keyword.merge(opts)

    method = Keyword.get(opts, :method) |> check_method()
    params = Keyword.get(opts, :params) |> check_params()
    description = Keyword.get(opts, :description) |> check_description()

    quote do
      @doc """
      `#{unquote(to_string(func_name))}` #{unquote(description)}
      """
      def unquote(func_name)(unquote_splicing(params)) do
        Jsonrpc.Request.new(method: unquote(method), params: [unquote_splicing(params)])
      end

      @doc false
      def unquote(func_name)(rpc_list, unquote_splicing(params)) do
        rpc_list
        |> Jsonrpc.Request.new(method: unquote(method), params: [unquote_splicing(params)])
      end
    end
  end

  defmacro rpc(func_name, opts) do
    throw("RPC spec not met: #{func_name} must be an atom, #{opts} must be a keyword list")
  end

  defp check_method(""), do: throw("RPC failed spec: Method is undefined")
  defp check_method(method) when is_binary(method), do: method
  defp check_method(_method), do: throw("RPC failed spec: Method must be binary")

  defp check_params(params) when is_list(params), do: params
  defp check_params(_params), do: throw("RPC failed spec: Params must be a list")

  defp check_description(""), do: throw("RPC failed spec: Description is undefined")
  defp check_description(description) when is_binary(description), do: description
  defp check_description(_description), do: throw("RPC failed spec: Description must be binary")
end

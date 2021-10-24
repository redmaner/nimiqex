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
      pool_size: 50,
      pool_count: System.schedulers_online(),
      pool_timeout: 10_000,
      receive_timeout: 10_000
    ]
  end

  defp name(name), do: :"#{__MODULE__}.#{name}"

  def child_spec(opts) do
    name = default_opts() |> Keyword.merge(opts) |> Keyword.fetch!(:name)

    %{
      id: name,
      start: {Nimiqex, :start_link, [opts]}
    }
  end

  def start_link(opts) do
    name = default_opts() |> Keyword.merge(opts) |> Keyword.fetch!(:name)
    GenServer.start_link(__MODULE__, opts, name: name(name))
  end

  def init(opts) do
    with opts <- default_opts() |> Keyword.merge(opts),
         {:ok, name} <- opts |> Keyword.fetch(:name),
         {:ok, url} <- opts |> Keyword.fetch(:url),
         {:ok, use_auth} <- opts |> Keyword.fetch(:use_auth),
         {:ok, username} <- opts |> Keyword.fetch(:username),
         {:ok, password} <- opts |> Keyword.fetch(:password),
         {:ok, protocol} <- opts |> Keyword.fetch(:protocol),
         {:ok, pool_size} <- opts |> Keyword.fetch(:pool_size),
         {:ok, pool_count} <- opts |> Keyword.fetch(:pool_count),
         {:ok, pool_timeout} <- opts |> Keyword.fetch(:pool_timeout),
         {:ok, receive_timeout} <- opts |> Keyword.fetch(:receive_timeout),
         http_pool <- new_http_pool(url, protocol, pool_size, pool_count),
         {:ok, pid} <- Jsonrpc.start_link(name: name, pool: http_pool) do
      state = %{
        finch: pid,
        name: name,
        url: url,
        use_auth: use_auth,
        username: username,
        password: password,
        pool_timeout: pool_timeout,
        receive_timeout: receive_timeout
      }

      {:ok, state}
    else
      error ->
        raise "Starting Nimiq RPC client failed: #{inspect(error, pretty: true)}"
    end
  end

  defp new_http_pool(url, protocol, pool_size, pool_count) when is_binary(url) do
    %{
      :default => [
        size: pool_size,
        count: pool_count,
        protocol: :http1
      ]
    }
    |> Map.put(url,
      size: pool_size,
      count: pool_count,
      protocol: protocol
    )
  end

  defp new_http_pool(urls, protocol, pool_size, pool_count) when is_list(urls) do
    urls
    |> Enum.reduce(%{}, fn node, acc ->
      acc |> Map.put(node, count: pool_count, size: pool_size, protocol: protocol)
    end)
    |> Map.put(:default, size: pool_size, count: pool_count, protocol: :http1)
  end

  def send(request, name \\ :default, url \\ :default) do
    GenServer.call(name(name), {:send_rpc, &Jsonrpc.call/2, request, url}, 60_000)
  end

  def send!(request, name \\ :default, url \\ :default) do
    GenServer.call(name(name), {:send_rpc, &Jsonrpc.call!/2, request, url}, 60_000)
  end

  def handle_call(
        {:send_rpc, jsonrpc_func, request, req_url},
        _from,
        state = %{
          name: name,
          url: state_url,
          pool_timeout: pool_timeout,
          receive_timeout: receive_timeout
        }
      ) do
    headers = create_headers(state)
    url = select_url(req_url, state_url)

    return =
      request
      |> jsonrpc_func.(
        name: name,
        url: url,
        headers: headers,
        pool_timeout: pool_timeout,
        receive_timeout: receive_timeout
      )

    {:reply, return, state}
  end

  defp create_headers(_state = %{password: password, username: username, use_auth: true}) do
    auth = Base.encode64(username <> ":" <> password)
    [{"Content-Type", "application/json"}, {"Authorization", "Basic " <> auth}]
  end

  defp create_headers(_state) do
    [{"Content-Type", "application/json"}]
  end

  defp select_url(:default, url) when is_binary(url), do: url
  defp select_url(:default, urls) when is_list(urls), do: urls |> Enum.random()
  defp select_url(req_url, _state_url) when is_binary(req_url), do: req_url
  defp select_url(req_url, _state_url), do: raise("The given url #{inspect(req_url)} is invalid")

  @doc false
  defmacro rpc(func_name, opts) when is_atom(func_name) and is_list(opts) do
    opts =
      [
        method: "",
        description: "",
        params: []
      ]
      |> Keyword.merge(opts)

    method =
      func_name
      |> to_string()
      |> String.split("_")
      |> Enum.reduce({0, ""}, &func_to_method/2)
      |> unwrap_method()

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

  defp func_to_method(part, {0, _method}), do: {1, part}
  defp func_to_method(part, {index, method}), do: {index, method <> String.capitalize(part)}

  defp unwrap_method({_index, method}), do: method

  defp check_params(params) when is_list(params), do: params
  defp check_params(_params), do: throw("RPC failed spec: Params must be a list")

  defp check_description(""), do: throw("RPC failed spec: Description is undefined")
  defp check_description(description) when is_binary(description), do: description
  defp check_description(_description), do: throw("RPC failed spec: Description must be binary")
end

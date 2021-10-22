defmodule Nimiqex.Network do
  @moduledoc """
  `Nimiqex.Network` provides RPC requests regarding Albatross network functionality
  """
  import Nimiqex, only: [rpc: 2]

  rpc :get_peer_id,
    description: "get peer id"

  rpc :get_peer_count,
    description: "get peer count"

  rpc :get_peer_list,
    description: "get peer list"
end

defmodule Nimiqex.Network do
  @moduledoc """
  `Nimiqex.Network` provides RPC requests regarding Albatross network functionality
  """
  import Nimiqex, only: [rpc: 2]

  rpc :get_peer_id,
    method: "getPeerId",
    description: "get peer id"

  rpc :get_peer_count,
    method: "getPeerCount",
    description: "get peer count"

  rpc :get_peer_list,
    method: "getPeerList",
    description: "get peer list"
end

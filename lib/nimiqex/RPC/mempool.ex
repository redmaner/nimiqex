defmodule Nimiqex.RPC.Mempool do
  @moduledoc """
  `Nimiqex.RPC.Mempool` provides RPC requests regarding Albatross mempool functionality
  """
  import Nimiqex.RPC, only: [rpc: 2]

  rpc :mempool,
    description: "retrieve mempool information"
end

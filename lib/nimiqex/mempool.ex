defmodule Nimiqex.Mempool do
  @moduledoc """
  `Nimiqex.Mempool` provides RPC requests regarding Albatross mempool functionality
  """
  import Nimiqex, only: [rpc: 2]

  rpc :mempool,
    method: "mempool",
    description: "retrieve mempool information"
end

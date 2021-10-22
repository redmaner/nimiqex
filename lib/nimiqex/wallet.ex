defmodule Nimiqex.Wallet do
  @moduledoc """
  `Nimiqex.Wallet` provides RPC requests regarding Albatross wallet functionality
  """
  import Nimiqex, only: [rpc: 2]

  rpc :import_raw_key,
    description: "imports an account to the node using its raw key",
    params: [key_data, passphrase]

  rpc :unlock_account,
    description: "unlocks an account for sending transactions",
    params: [address, passphrase, duration]

  rpc :lock_account,
    description: "locks account",
    params: [address]

  rpc :create_account,
    description: "creates a new account",
    params: [passphrase]
end

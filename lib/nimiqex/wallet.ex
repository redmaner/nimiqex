defmodule Nimiqex.Wallet do
  @moduledoc """
  `Nimiqex.Wallet` provides RPC requests regarding Albatross wallet functionality
  """
  import Nimiqex, only: [rpc: 2]

  rpc :list_accounts,
    description: "list accounts present on the node"

  rpc :import_raw_key,
    description: "imports an account to the node using its raw key",
    params: [key_data, passphrase],
    spec: [binary(), binary() | nil]

  rpc :is_account_imported,
    description: "returns whether the given account is imported at the node",
    params: [address],
    spec: [binary()]

  rpc :unlock_account,
    description: "unlocks an account for sending transactions",
    params: [address, passphrase, duration],
    spec: [binary(), binary() | nil, integer() | nil]

  rpc :is_account_unlocked,
    description: "returns whether the given account is unlocked on the node",
    params: [address],
    spec: [binary()]

  rpc :lock_account,
    description: "locks account",
    params: [address],
    spec: [binary()]

  rpc :create_account,
    description: "creates a new account",
    params: [passphrase],
    spec: [binary()]

  rpc :sign,
    description: "sign a message",
    params: [message, address, passphrase, is_hex],
    spec: [binary(), binary(), binary(), boolean()]

  rpc :verify_signature,
    description: "verify signature of a message",
    params: [message, public_key, signature, is_hex],
    spec: [binary(), binary(), binary(), boolean()]
end

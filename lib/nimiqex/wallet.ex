defmodule Nimiqex.Wallet do
  @moduledoc """
  `Nimiqex.Wallet` provides RPC requests regarding Albatross wallet functionality
  """
  import Nimiqex, only: [rpc: 2]

  @spec list_accounts() :: Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :list_accounts,
    description: "list accounts present on the node"

  @spec import_raw_key(key_data :: binary(), passphrase :: binary()) ::
          Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :import_raw_key,
    description: "imports an account to the node using its raw key",
    params: [key_data, passphrase]

  @spec is_account_imported(address :: binary()) :: Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :is_account_imported,
    description: "returns whether the given account is imported at the node",
    params: [address]

  @spec unlock_account(address :: binary(), passphrase :: binary(), duration :: integer()) ::
          Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :unlock_account,
    description: "unlocks an account for sending transactions",
    params: [address, passphrase, duration]

  @spec is_account_unlocked(address :: binary()) :: Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :is_account_unlocked,
    description: "returns whether the given account is unlocked on the node",
    params: [address]

  @spec lock_account(address :: binary()) :: Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :lock_account,
    description: "locks account",
    params: [address]

  @spec create_account(passphrase :: binary()) :: Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :create_account,
    description: "creates a new account",
    params: [passphrase]

  @spec sign(
          message :: binary(),
          address :: binary(),
          passphrase :: binary(),
          is_hex :: boolean()
        ) :: Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :sign,
    description: "sign a message",
    params: [message, address, passphrase, is_hex]

  @spec verify_signature(
          message :: binary(),
          public_key :: binary(),
          signature :: binary(),
          is_hex :: boolean()
        ) :: Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :verify_signature,
    description: "verify signature of a message",
    params: [message, public_key, signature, is_hex]
end

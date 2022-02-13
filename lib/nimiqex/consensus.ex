defmodule Nimiqex.Consensus do
  @moduledoc """
  `Nimiqex.Consensus` provides RPC requests regarding Albatross consensus functionality
  """
  import Nimiqex, only: [rpc: 2]

  rpc :is_consensus_established,
    description: "returns the consensus status"

  rpc :get_raw_transaction_info,
    description: "get info for raw transaction",
    params: [raw_tx],
    spec: [binary()]

  rpc :send_raw_transaction,
    description: "send a raw hex encoded transaction",
    params: [raw_tx],
    spec: [binary()]

  rpc :create_basic_transaction,
    description: "create a basic transaction",
    params: [wallet, recipient, value, fee, validity_start_height],
    spec: [binary(), binary(), integer(), integer(), binary()]

  rpc :send_basic_transaction,
    description: "send a basic transaction",
    params: [wallet, recipient, value, fee, validity_start_height],
    spec: [binary(), binary(), integer(), integer(), binary()]

  rpc :create_new_staker_transaction,
    description: "create a new staker transaction",
    params: [sender_wallet, staker_wallet, delegation, value, fee, validaty_start_height],
    spec: [binary(), binary(), binary(), integer(), integer(), binary()]

  rpc :send_new_staker_transaction,
    description: "send a new staker transaction",
    params: [sender_wallet, staker_wallet, delegation, value, fee, validaty_start_height],
    spec: [binary(), binary(), binary(), integer(), integer(), binary()]

  rpc :create_stake_transaction,
    description: "create a stake transaction to start staking using the selected validator",
    params: [sender_wallet, staker_wallet, value, fee, validity_start_height],
    spec: [binary(), binary(), integer(), integer(), binary()]

  rpc :send_stake_transaction,
    description: "send a stake transaction to start staking using the selected validator",
    params: [sender_wallet, staker_wallet, value, fee, validity_start_height],
    spec: [binary(), binary(), integer(), integer(), binary()]

  rpc :create_update_transaction,
    description: "create update transaction to update the validator of the staker wallet",
    params: [sender_wallet, staker_wallet, new_delegation, fee, validity_start_height],
    spec: [binary() | nil, binary(), binary(), integer(), binary()]

  rpc :send_update_transaction,
    description: "send update transaction to update the validator of the staker wallet",
    params: [sender_wallet, staker_wallet, new_delegation, fee, validity_start_height],
    spec: [binary() | nil, binary(), binary(), integer(), binary()]

  rpc :create_unstake_transaction,
    description:
      "create unstake transaction to remove an amount of the active stake of the staker wallet",
    params: [sender_wallet, staker_wallet, value, fee, validity_start_height],
    spec: [binary(), binary(), integer(), integer(), binary()]

  rpc :send_unstake_transaction,
    description:
      "send unstake transaction to remove an amount of the active stake of the staker wallet",
    params: [sender_wallet, staker_wallet, value, fee, validity_start_height],
    spec: [binary(), binary(), integer(), integer(), binary()]
end

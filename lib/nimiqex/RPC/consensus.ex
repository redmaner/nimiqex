defmodule Nimiqex.RPC.Consensus do
  @moduledoc """
  `Nimiqex.RPC.Consensus` provides RPC requests regarding Albatross consensus functionality
  """
  import Nimiqex.RPC, only: [rpc: 2]

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

  rpc :create_update_staker_transaction,
    description: "create update transaction to update the validator of the staker wallet",
    params: [sender_wallet, staker_wallet, new_delegation, fee, validity_start_height],
    spec: [binary() | nil, binary(), binary(), integer(), binary()]

  rpc :send_update_staker_transaction,
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

  rpc :create_new_validator_transaction,
    description: "send new validator transation to start a new validator",
    params: [
      sender_wallet,
      validator_wallet,
      signing_key,
      voting_key,
      reward_address,
      signal_data,
      fee,
      validity_start_height
    ],
    spec: [binary(), binary(), binary(), binary(), binary(), binary(), integer(), binary()]

  rpc :send_new_validator_transaction,
    description: "send new validator transation to start a new validator",
    params: [
      sender_wallet,
      validator_wallet,
      signing_key,
      voting_key,
      reward_address,
      signal_data,
      fee,
      validity_start_height
    ],
    spec: [binary(), binary(), binary(), binary(), binary(), binary(), integer(), binary()]

  rpc :create_reactivate_validator_transaction,
    description: "create transaction to reactivate an inactive validator",
    params: [
      sender_wallet,
      validator_wallet,
      signing_secret_key,
      fee,
      validity_start_height
    ],
    spec: [binary(), binary(), binary(), integer(), binary()]

  rpc :send_reactivate_validator_transaction,
    description: "send transaction to reactivate an inactive validator",
    params: [
      sender_wallet,
      validator_wallet,
      signing_secret_key,
      fee,
      validity_start_height
    ],
    spec: [binary(), binary(), binary(), integer(), binary()]
end

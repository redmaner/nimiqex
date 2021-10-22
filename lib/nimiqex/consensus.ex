defmodule Nimiqex.Consensus do
  @moduledoc """
  `Nimiqex.Consensus` provides RPC requests regarding Albatross consensus functionality
  """
  import Nimiqex, only: [rpc: 2]

  rpc :is_consensus_established,
    method: "isConsensusEstablished",
    description: "returns the consensus status"

  rpc :get_raw_transaction_info,
    method: "getRawTransactionInfo",
    description: "get info for raw transaction",
    params: [raw_tx]

  rpc :send_raw_transaction,
    method: "sendRawTransaction",
    description: "send a raw hex encoded transaction",
    params: [raw_tx]

  rpc :create_basic_transaction,
    method: "createBasicTransaction",
    description: "create a basic transaction",
    params: [wallet, recipient, value, fee, validity_start_height]

  rpc :send_basic_transaction,
    method: "sendBasicTransaction",
    description: "send a basic transaction",
    params: [wallet, recipient, value, fee, validity_start_height]

  rpc :create_new_staker_transaction,
    method: "createNewStakerTransaction",
    description: "create a new staker transaction",
    params: [sender_wallet, staker_wallet, delegation, value, fee, validaty_start_height]

  rpc :send_new_staker_transaction,
    method: "sendNewStakerTransaction",
    description: "send a new staker transaction",
    params: [sender_wallet, staker_wallet, delegation, value, fee, validaty_start_height]

  rpc :create_stake_transaction,
    method: "createStakeTransaction",
    description: "create a stake transaction to start staking using the selected validator",
    params: [sender_wallet, staker_wallet, value, fee, validity_start_height]

  rpc :send_stake_transaction,
    method: "sendStakeTransaction",
    description: "send a stake transaction to start staking using the selected validator",
    params: [sender_wallet, staker_wallet, value, fee, validity_start_height]
end

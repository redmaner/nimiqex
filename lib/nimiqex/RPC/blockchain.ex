defmodule Nimiqex.RPC.Blockchain do
  @moduledoc """
  `Nimiqex.RPC.Blockchain` provides RPC requests regarding Albatross blockchain functionality
  """
  import Nimiqex.RPC, only: [rpc: 2]

  rpc :get_block_number,
    description: "retrieves latest block number"

  rpc :get_batch_number,
    description: "retrieves latest batch number"

  rpc :get_epoch_number,
    description: "retrieves latest epoch number"

  rpc :get_block_by_hash,
    description:
      "retrieves block by hash. Takes block_hash as string and full_transactions as boolean. If full transactions is true the full transactions are returned otherwise only the transaction hashes are returned",
    params: [block_hash, full_transactions],
    spec: [binary(), boolean()]

  rpc :get_block_by_number,
    description:
      "retrieves block by number. Takes block_number as int and full_transactions as boolean. If full transactions is true the full transactions are returned otherwise only the transaction hashes are returned",
    params: [block_number, full_transactions],
    spec: [integer(), boolean()]

  rpc :get_latest_block,
    description:
      "retrieves latest block. If full transactions is true the full transactions are returned otherwise only the transaction hashes are returned",
    params: [full_transactions],
    spec: [boolean()]

  rpc :get_slot_at,
    description: "retrieves slot",
    params: [block_number, view_number],
    spec: [integer(), integer()]

  rpc :get_transaction_by_hash,
    description: "get transaction by hash",
    params: [hash],
    spec: [binary()]

  rpc :get_transactions_by_block_number,
    description: "retrieves extended transactions for given block",
    params: [block_number],
    spec: [integer()]

  rpc :get_inherents_by_block_number,
    description: "retrieve inherents by block number",
    params: [block_number],
    spec: [integer()]

  rpc :get_transactions_by_batch_number,
    description: "retrieves transactions for the given batch",
    params: [batch_number],
    spec: [integer()]

  rpc :get_inherents_by_batch_number,
    description: "retrieves inherents for the given batch",
    params: [batch_number],
    spec: [integer()]

  rpc :get_transaction_hashes_by_address,
    description: "get transaction hashes for the given address",
    params: [address, max_transactions],
    spec: [binary(), integer()]

  rpc :get_transactions_by_address,
    description: "get transactions for the given address",
    params: [address, max_transactions],
    spec: [binary(), integer()]

  rpc :get_active_validators,
    description: "retrieves list of active validators"

  rpc :get_validator_by_address,
    description: "retrieves validator by addres.",
    params: [address],
    spec: [binary()]

  rpc :get_stakers_by_validator_address,
    description:
      "retrieves stakers for given validators. WARNINNG: this is a CPU intensive operation",
    params: [address],
    spec: [binary()]

  rpc :get_staker_by_address,
    description: "retrieves staker for the given addres",
    params: [address],
    spec: [binary()]

  rpc :get_account_by_address,
    description: "retrieve account for the given address",
    params: [address],
    spec: [binary()]

  rpc :get_current_slashed_slots,
    description: "get slashed slots for current epoch"

  rpc :get_previous_slashed_slots,
    description: "get slashed slots for previous epoch"

  rpc :get_parked_set,
    description: "get parked set"
end

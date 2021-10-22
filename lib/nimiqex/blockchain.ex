defmodule Nimiqex.Blockchain do
  @moduledoc """
  `Nimiqex.Blockchain` provides RPC requests regarding Albatross blockchain functionality
  """
  import Nimiqex, only: [rpc: 2]

  @spec get_block_number() :: Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_block_number,
    description: "retrieves latest block number"

  @spec get_batch_number() :: Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_batch_number,
    description: "retrieves latest batch number"

  @spec get_epoch_number() :: Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_epoch_number,
    description: "retrieves latest epoch number"

  @spec get_block_by_hash(block_hash :: binary(), full_transactions :: boolean()) ::
          Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_block_by_hash,
    description:
      "retrieves block by hash. Takes block_hash as string and full_transactions as boolean. If full transactions is true the full transactions are returned otherwise only the transaction hashes are returned",
    params: [block_hash, full_transactions]

  @spec get_block_by_number(block_number :: integer(), full_transactions :: boolean()) ::
          Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_block_by_number,
    description:
      "retrieves block by number. Takes block_number as int and full_transactions as boolean. If full transactions is true the full transactions are returned otherwise only the transaction hashes are returned",
    params: [block_number, full_transactions]

  @spec get_latest_block(full_transactions :: boolean()) ::
          Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_latest_block,
    description:
      "retrieves latest block. If full transactions is true the full transactions are returned otherwise only the transaction hashes are returned",
    params: [full_transactions]

  @spec get_slot_at(block_number :: integer(), view_number :: integer()) ::
          Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_slot_at,
    description: "retrieves slot",
    params: [block_number, view_number]

  @spec get_transactions_by_block_number(block_number :: integer()) ::
          Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_transactions_by_block_number,
    description: "retrieves extended transactions for given block",
    params: [block_number]

  @spec get_inherents_by_block_number(block_number :: integer()) ::
          Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_inherents_by_block_number,
    description: "retrieve inherents by block number",
    params: [block_number]

  @spec get_transactions_by_batch_number(batch_number :: integer()) ::
          Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_transactions_by_batch_number,
    description: "retrieves transactions for the given batch",
    params: [batch_number]

  @spec get_inherents_by_batch_number(batch_number :: integer()) ::
          Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_inherents_by_batch_number,
    description: "retrieves inherents for the given batch",
    params: [batch_number]

  @spec get_transaction_hashes_by_address(address :: binary(), max_transactions :: integer()) ::
          Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_transaction_hashes_by_address,
    description: "get transaction hashes for the given address",
    params: [address, max_transactions]

  @spec get_transactions_by_address(address :: binary(), max_transactions :: integer()) ::
          Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_transactions_by_address,
    description: "get transactions for the given address",
    params: [address, max_transactions]

  @spec get_active_validators() :: Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_active_validators,
    description: "retrieves list of active validators"

  @spec get_validator_by_address(validator_address :: binary(), include_stakers :: boolean()) ::
          Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_validator_by_address,
    description:
      "retrieves validator by addres. If include_stakers is true, the delegated stakers for the given validator are returned as well",
    params: [address, include_stakers]

  @spec get_staker_by_address(staker_address :: binary()) ::
          Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_staker_by_address,
    description: "retrieves staker for the given addres",
    params: [address]

  @spec get_account_by_address(account_address :: binary()) ::
          Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_account_by_address,
    description: "retrieve account for the given address",
    params: [address]

  @spec get_current_slashed_slots() :: Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_current_slashed_slots,
    description: "get slashed slots for current epoch"

  @spec get_previous_slashed_slots() :: Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_previous_slashed_slots,
    description: "get slashed slots for previous epoch"

  @spec get_parked_set() :: Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_parked_set,
    description: "get parked set"
end

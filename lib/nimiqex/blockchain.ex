defmodule Nimiqex.Blockchain do
  @moduledoc """
  `Nimiqex.Blockchain` provides RPC requests regarding Albatross blockchain functionality
  """
  import Nimiqex, only: [rpc: 2]

  @spec get_block_number() :: Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_block_number,
    method: "getBlockNumber",
    description: "retrieves latest block number"

  @spec get_batch_number() :: Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_batch_number,
    method: "getBatchNumber",
    description: "retrieves latest batch number"

  @spec get_epoch_number() :: Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_epoch_number,
    method: "getEpochNumber",
    description: "retrieves latest epoch number"

  @spec get_block_by_hash(block_hash :: binary(), full_transactions :: boolean()) ::
          Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_block_by_hash,
    method: "getBlockByHash",
    description:
      "retrieves block by hash. Takes block_hash as string and full_transactions as boolean. If full transactions is true the full transactions are returned otherwise only the transaction hashes are returned",
    params: [block_hash, full_transactions]

  @spec get_block_by_number(block_number :: integer(), full_transactions :: boolean()) ::
          Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_block_by_number,
    method: "getBlockByNumber",
    description:
      "retrieves block by number. Takes block_number as int and full_transactions as boolean. If full transactions is true the full transactions are returned otherwise only the transaction hashes are returned",
    params: [block_number, full_transactions]

  @spec get_latest_block(full_transactions :: boolean()) ::
          Jsonrpc.Request.t() | [Jsonrpc.Request.t()]
  rpc :get_latest_block,
    method: "getLatestBlock",
    description:
      "retrieves latest block. If full transactions is true the full transactions are returned otherwise only the transaction hashes are returned",
    params: [full_transactions]

  rpc :get_transactions_by_block_number,
    method: "getTransactionsByBlockNumber",
    description: "retrieves extended transactions for given block",
    params: [block_number]

  rpc :get_inherents_by_block_number,
    method: "getInherentsByBlockNumber",
    description: "retrieve inherents by block number",
    params: [block_number]

  rpc :get_transactions_by_batch_number,
    method: "getTransactionsByBatchNumber",
    description: "retrieves transactions for the given batch",
    params: [batch_number]

  rpc :get_inherents_by_batch_number,
    method: "getInherentsByBatchNumber",
    description: "retrieves inherents for the given batch",
    params: [batch_number]

  rpc :get_active_validators,
    method: "getActiveValidators",
    description: "retrieves list of active validators"

  rpc :get_validator_by_address,
    method: "getValidatorByAddress",
    description:
      "retrieves validator by addres. If include_stakers is true, the delegated stakers for the given validator are returned as well",
    params: [address, include_stakers]

  rpc :get_staker_by_address,
    method: "getStakerByAddress",
    description: "retrieves staker for the given addres",
    params: [address]

  rpc :get_account_by_address,
    method: "getAccountByAddress",
    description: "retrieve account for the given address",
    params: [address]
end

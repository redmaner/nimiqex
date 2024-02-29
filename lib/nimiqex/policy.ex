defmodule Nimiqex.Policy do
  @doc """
  Returns the batch size as an integer
  """
  def batch_size() do
    Application.get_env(:nimiqex, :policy_batch_size, 60)
  end

  @doc """
  Returns the epoch size as an integer
  """
  def epoch_size() do
    Application.get_env(:nimiqex, :policy_epoch_size, 43_200)
  end

  @doc """
  Returns the amount of batches in an epoch
  """
  def batches_in_epoch() do
    Application.get_env(:nimiqex, :policy_batches_in_epoch, 720)
  end

  @doc """
  Returns the genesis block number
  """
  def genesis_block_number() do
    Application.get_env(:nimiqex, :policy_genesis_block_number, 0)
  end

  @doc """
  Returns the batch number for the given block number
  """
  def get_batch_from_block_number(block_number) do
    batch_size()
    |> calculate_size_for_block(block_number)
  end

  @doc """
  Returns the epoch number for the given block number
  """
  def get_epoch_from_block_number(block_number) do
    epoch_size()
    |> calculate_size_for_block(block_number)
  end

  @doc """
  Returns the epoch number for the given batch number
  """
  def get_epoch_from_batch_number(batch_number) do
    block_number = batch_number * batch_size() + genesis_block_number()

    epoch_size()
    |> calculate_size_for_block(block_number)
  end

  @doc """
  Returns the block number for the given epoch
  """
  def get_block_number_for_epoch(epoch_number) do
    epoch_number * epoch_size() + genesis_block_number()
  end

  @doc """
  Returns the block number for the given batch
  """
  def get_block_number_for_batch(batch_number) do
    batch_number * batch_size() + genesis_block_number()
  end

  defp calculate_size_for_block(size, block_number) do
    block_number
    |> Kernel.-(genesis_block_number())
    |> Kernel./(size)
    |> ceil()
  end

  @doc """
  Determines the block type based on block number
  """
  def get_block_type_by_block_number(block_number) do
    block_number = block_number - genesis_block_number()
    batch_size = batch_size()
    epoch_size = epoch_size()

    cond do
      rem(block_number, batch_size) == 0 and rem(block_number, epoch_size) == 0 ->
        :ELECTION

      rem(block_number, batch_size) == 0 ->
        :CHECKPOINT

      true ->
        :MICRO
    end
  end

  @doc """
  Returns if the given block is the last micro block
  of its current epoch
  """
  def is_last_micro_block_for_epoch?(block_number) do
    case get_block_type_by_block_number(block_number) do
      :MICRO ->
        curr_epoch = get_epoch_from_block_number(block_number)
        next_epoch = curr_epoch + 1

        get_epoch_from_block_number(block_number + 2) == next_epoch

      _else ->
        false
    end
  end
end

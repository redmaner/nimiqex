defmodule Nimiqex.Address do
  @ccode "NQ"
  @doc """
  Allows to extract the address from the transaction `proof` field
  This is the address that signed the transaction
  """
  def extract_address_from_transaction_proof(proof) do
    proof_decoded = proof |> :binary.decode_hex()

    proof_decoded
    |> binary_part(0, 1)
    |> extract_proof_address_by_type(proof_decoded)
  end

  defp extract_proof_address_by_type(_type_byte = <<0>>, proof_decoded) do
    proof_decoded
    |> extract_address_from_public_key(32)
  end

  defp extract_proof_address_by_type(_type_byte = <<1>>, proof_decoded) do
    proof_decoded
    |> extract_address_from_public_key(33)
  end

  defp extract_address_from_public_key(proof_decoded, pub_key_length) do
    proof_decoded
    |> binary_part(1, pub_key_length)
    |> Blake2.hash2b(32)
    |> case do
      hash when is_binary(hash) ->
        hash
        |> binary_part(0, 20)
        |> to_user_friendly_address()

      :error ->
        {:error, :blake2b_hash_failed}
    end
  end

  @doc """
  decode_recipient_data extracts the transaction type and beneficiary address from `recipientData` which is field
  present in transactions to the staking contract.
  """
  def decode_recipient_data(data) do
    data
    |> :binary.decode_hex()
    |> case do
      data when byte_size(data) == 21 ->
        action_type =
          data
          |> binary_part(0, 1)
          |> extract_recipient_data_type()

        address =
          data
          |> binary_part(1, 20)
          |> to_user_friendly_address()

        {:ok, action_type, address}

      _other ->
        {:error, :invalid_data}
    end
  end

  defp extract_recipient_data_type(<<0>>), do: :CREATE_VALIDATOR
  defp extract_recipient_data_type(<<1>>), do: :UPDATE_VALIDATOR
  defp extract_recipient_data_type(<<2>>), do: :DEACTIVATE_VALIDATOR
  defp extract_recipient_data_type(<<3>>), do: :REACTIVATE_VALIDATOR
  defp extract_recipient_data_type(<<4>>), do: :RETIRE_VALIDATOR
  defp extract_recipient_data_type(<<5>>), do: :CREATE_STAKER
  defp extract_recipient_data_type(<<6>>), do: :ADD_STAKE
  defp extract_recipient_data_type(<<7>>), do: :UPDATE_STAKER
  defp extract_recipient_data_type(<<8>>), do: :SET_ACTIVE_STAKE
  defp extract_recipient_data_type(<<9>>), do: :RETIRE_STAKE

  @doc """
  decode_from_hex decodes a raw hex encoded address to a user friendly address
  """
  def decode_from_hex(hex) do
    hex
    |> :binary.decode_hex()
    |> to_user_friendly_address()
  end

  def decode_from_friendly(friendly) do
    cleaned = String.replace(friendly, " ", "", [global: true])
    cleaned = binary_part(cleaned, 4, String.length(cleaned)-4)
    Nimiqex.Base.decode32(cleaned, false)
  end

  @doc """
  to_user_friendly_address transforms a raw Nimiq address to the user friendly variant
  """
  def to_user_friendly_address(bytes) do
    base32 = Nimiqex.Base.encode32(bytes, "")
    iban_check = "00" <> ((98 - iban_check(base32 <> @ccode <> "00")) |> to_string())
    check = String.slice(iban_check, String.length(iban_check) - 2, 2)

    (@ccode <> check <> base32)
    |> String.codepoints()
    |> Stream.chunk_every(4)
    |> Stream.map(&Enum.join/1)
    |> Enum.reduce("", &(&2 <> " " <> &1))
    |> String.trim()
  end

  defp iban_check(str) do
    num =
      str
      |> String.codepoints()
      |> Enum.map(fn c ->
        code = :binary.first(c)

        if code >= 48 and code <= 57 do
          c
        else
          (code - 55) |> to_string()
        end
      end)
      |> Enum.join()

    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while("", &reduce_iban_number(&1, &2, num))
    |> String.to_integer()
  end

  defp reduce_iban_number(i, acc, num) do
    if i < ceil(String.length(num) / 6) do
      acc =
        (acc <> String.slice(num, i * 6, 6))
        |> String.to_integer()
        |> rem(97)
        |> to_string()

      {:cont, acc}
    else
      {:halt, acc}
    end
  end
end

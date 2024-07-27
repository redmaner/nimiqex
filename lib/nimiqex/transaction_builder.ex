defmodule Nimiqex.TransactionBuilder do
  @tx_type_basic <<0>>
  @tx_type_extended <<1>>

  @account_type_basic <<0>>
  @account_type_staking <<3>>

  @staking_contract_address <<0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                              0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01>>

  @type t :: %__MODULE__{
          type: bitstring(),
          sender: bitstring(),
          sender_type: bitstring(),
          sender_data: bitstring(),
          recipient: bitstring(),
          recipient_type: bitstring(),
          recipient_data: bitstring(),
          value: non_neg_integer(),
          fee: non_neg_integer(),
          validity_start_height: non_neg_integer(),
          network_id: bitstring(),
          flags: bitstring(),
          signature: bitstring(),
          public_key: bitstring()
        }

  defstruct [
    :type,
    :sender,
    :sender_type,
    :sender_data,
    :recipient,
    :recipient_type,
    :recipient_data,
    :value,
    :fee,
    :validity_start_height,
    :network_id,
    :flags,
    :signature,
    :public_key
  ]

  @spec new_basic_transaction(
          bitstring(),
          bitstring(),
          non_neg_integer(),
          non_neg_integer(),
          non_neg_integer(),
          bitstring()
        ) ::
          Nimiqex.TransactionBuilder.t()
  def new_basic_transaction(
        sender,
        recipient,
        value,
        fee,
        validity_start_height,
        network_id
      ) do
    %__MODULE__{
      type: @tx_type_basic,
      sender: sender,
      sender_type: @account_type_basic,
      sender_data: <<>>,
      recipient: recipient,
      recipient_type: @account_type_basic,
      recipient_data: <<>>,
      value: value,
      fee: fee,
      validity_start_height: validity_start_height,
      network_id: network_id,
      flags: <<0>>,
      signature: <<>>,
      public_key: <<>>
    }
  end

  def new_add_stake_transaction(
        sender,
        recipient,
        value,
        fee,
        validity_start_height,
        network_id
      ) do
    {:ok, recipient_data} =
      Nimiqex.Serializer.new()
      |> Nimiqex.Serializer.serialize_bytes(<<6>>)
      |> Nimiqex.Serializer.serialize_address(recipient)
      |> Nimiqex.Serializer.unwrap()

    %__MODULE__{
      type: @tx_type_extended,
      sender: sender,
      sender_type: @account_type_basic,
      sender_data: <<>>,
      recipient: @staking_contract_address,
      recipient_type: @account_type_staking,
      recipient_data: recipient_data,
      value: value,
      fee: fee,
      validity_start_height: validity_start_height,
      network_id: network_id,
      flags: <<0>>,
      signature: <<>>,
      public_key: <<>>
    }
  end

  def sign(tx = %__MODULE__{}, priv_key, public_key) do
    with {:ok, signing_payload} <- create_signing_payload(tx) do
      signature = Ed25519.signature(signing_payload, priv_key, public_key)
      %__MODULE__{tx | signature: signature, public_key: public_key}
    end
  end

  defp create_signing_payload(%__MODULE__{
         recipient_data: recipient_data,
         sender: sender,
         sender_type: sender_type,
         recipient: recipient,
         recipient_type: recipient_type,
         value: value,
         fee: fee,
         validity_start_height: validity_start_height,
         network_id: network_id,
         flags: flags,
         sender_data: sender_data
       }) do
    Nimiqex.Serializer.new()
    |> Nimiqex.Serializer.serialize_uint16_big_endian(length(recipient_data))
    |> Nimiqex.Serializer.serialize_bytes(recipient_data)
    |> Nimiqex.Serializer.serialize_address(sender)
    |> Nimiqex.Serializer.serialize_bytes(sender_type)
    |> Nimiqex.Serializer.serialize_address(recipient)
    |> Nimiqex.Serializer.serialize_bytes(recipient_type)
    |> Nimiqex.Serializer.serialize_uint64_big_endian(value)
    |> Nimiqex.Serializer.serialize_uint64_big_endian(fee)
    |> Nimiqex.Serializer.serialize_uint32_big_endian(validity_start_height)
    |> Nimiqex.Serializer.serialize_bytes(network_id)
    |> Nimiqex.Serializer.serialize_bytes(flags)
    |> Nimiqex.Serializer.serialize_varint(length(sender_data))
    |> Nimiqex.Serializer.serialize_bytes(sender_data)
    |> Nimiqex.Serializer.unwrap()
  end

  def encode(%__MODULE__{
        type: <<0>>,
        signature: signature,
        public_key: public_key,
        recipient: recipient,
        value: value,
        fee: fee,
        network_id: network_id
      })
      when byte_size(signature) > 0 do
    Nimiqex.Serializer.new()
    # transaction type
    |> Nimiqex.Serializer.serialize_bytes(<<0>>)
    # signature type
    |> Nimiqex.Serializer.serialize_bytes(<<0>>)
    |> Nimiqex.Serializer.serialize_bytes(public_key)
    |> Nimiqex.Serializer.serialize_bytes(recipient)
    |> Nimiqex.Serializer.serialize_uint64_big_endian(value)
    |> Nimiqex.Serializer.serialize_uint64_big_endian(fee)
    |> Nimiqex.Serializer.serialize_bytes(network_id)
    |> Nimiqex.Serializer.serialize_bytes(signature)
    |> Nimiqex.Serializer.unwrap()
    |> hex_encode_transaction()
  end

  defp hex_encode_transaction(err = {:error, _reason}), do: err
  defp hex_encode_transaction({:ok, tx}), do: {:ok, :binary.encode_hex(tx)}
end

defmodule Nimiqex.Serializer do
  @moduledoc """
  A module to serialize data into the Nimiq blockchain representation. Mostly used for
  constructing signature payloads and transactions
  """

  import Bitwise

  @type t() :: %__MODULE__{
          buffer: bitstring(),
          error: term()
        }
  defstruct [:buffer, :error]

  @spec new() :: t()
  def new() do
    %__MODULE__{
      buffer: <<>>,
      error: nil
    }
  end

  @doc """
  Serialize an address to the buffer
  """
  @spec serialize_address(Nimiqex.Serializer.t(), binary()) :: Nimiqex.Serializer.t()
  def serialize_address(serializer = %__MODULE__{error: error}, _x)
      when not is_nil(error) do
    serializer
  end

  def serialize_address(serializer = %__MODULE__{buffer: buffer}, address)
      when is_binary(address) and byte_size(address) == 20 do
    %__MODULE__{serializer | buffer: <<buffer::binary, address::binary>>}
  end

  def serialize_address(serializer = %__MODULE__{}, _address) do
    %__MODULE__{serializer | error: "invalid address"}
  end

  @doc """
  Serialize bytes to the buffer
  """
  def serialize_bytes(serializer = %__MODULE__{error: error}, _x)
      when not is_nil(error) do
    serializer
  end

  def serialize_bytes(serializer = %__MODULE__{buffer: buffer}, data) when is_bitstring(data) do
    %__MODULE__{serializer | buffer: <<buffer::binary, data::binary>>}
  end

  @doc """
  Serialize a number to the buffer in uint16 big endian format
  """
  @spec serialize_uint16_big_endian(Nimiqex.Serializer.t(), non_neg_integer()) ::
          Nimiqex.Serializer.t()
  def serialize_uint16_big_endian(serializer = %__MODULE__{error: error}, _x)
      when not is_nil(error) do
    serializer
  end

  def serialize_uint16_big_endian(serializer = %__MODULE__{buffer: buffer}, x)
      when is_integer(x) do
    %__MODULE__{serializer | buffer: <<buffer::binary, x::16-big>>}
  end

  @doc """
  Serialize a number to the buffer in uint32 big endian format
  """
  @spec serialize_uint32_big_endian(Nimiqex.Serializer.t(), non_neg_integer()) ::
          Nimiqex.Serializer.t()
  def serialize_uint32_big_endian(serializer = %__MODULE__{error: error}, _x)
      when not is_nil(error) do
    serializer
  end

  def serialize_uint32_big_endian(serializer = %__MODULE__{buffer: buffer}, x)
      when is_integer(x) do
    %__MODULE__{serializer | buffer: <<buffer::binary, x::32-big>>}
  end

  @doc """
  Serialize a number to the buffer in uint64 big endian format
  """
  @spec serialize_uint64_big_endian(Nimiqex.Serializer.t(), non_neg_integer()) ::
          Nimiqex.Serializer.t()
  def serialize_uint64_big_endian(serializer = %__MODULE__{error: error}, _x)
      when not is_nil(error) do
    serializer
  end

  def serialize_uint64_big_endian(serializer = %__MODULE__{buffer: buffer}, x)
      when is_integer(x) do
    %__MODULE__{serializer | buffer: <<buffer::binary, x::64-big>>}
  end

  @doc """
  Serialize a number to the buffer in varint format
  """
  @spec serialize_varint(Nimiqex.Serializer.t(), non_neg_integer()) :: Nimiqex.Serializer.t()
  def serialize_varint(serializer = %__MODULE__{error: error}, _x)
      when not is_nil(error) do
    serializer
  end

  def serialize_varint(serializer = %__MODULE__{buffer: buffer}, x)
      when is_integer(x) do
    encoded = encode_varint(x)
    %__MODULE__{serializer | buffer: <<buffer::binary, encoded::binary>>}
  end

  defp encode_varint(v) when v < 128, do: <<v>>
  defp encode_varint(v), do: <<1::1, v::7, encode_varint(v >>> 7)::binary>>

  @doc """
  Helper to unwrap seralized data
  """
  @spec unwrap(Nimiqex.Serializer.t()) :: {:error, any()} | {:ok, bitstring()}
  def unwrap(%__MODULE__{error: error}) when not is_nil(error) do
    {:error, error}
  end

  def unwrap(%__MODULE__{buffer: buffer}) when is_bitstring(buffer) do
    {:ok, buffer}
  end
end

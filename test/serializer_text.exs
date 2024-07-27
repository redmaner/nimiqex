defmodule Nimiqex.SerializerTest do
  use ExUnit.Case

  test "varint encoding" do
    {:ok, buffer} =
      Nimiqex.Serializer.new()
      |> Nimiqex.Serializer.serialize_varint(21)
      |> Nimiqex.Serializer.unwrap()

    assert :binary.encode_hex(buffer) == "15"
  end
end

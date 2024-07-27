defmodule Nimiqex.Base do
  import Bitwise

  @nimiq_alphabet ~c{0123456789ABCDEFGHJKLMNPQRSTUVXY}

  ## Nimiq base 32 encoding
  to_encode_list = fn alphabet ->
    for e1 <- alphabet, e2 <- alphabet, do: bsl(e1, 8) + e2
  end

  encoded = to_encode_list.(@nimiq_alphabet)
  encode_name = :encode32

  @compile {:inline, [{encode_name, 1}]}
  def unquote(encode_name)(byte) do
    elem({unquote_splicing(encoded)}, byte)
  end

  def unquote(encode_name)(<<c1::10, c2::10, c3::10, c4::10, rest::binary>>, acc) do
    unquote(encode_name)(
      rest,
      <<
        acc::binary,
        unquote(encode_name)(c1)::16,
        unquote(encode_name)(c2)::16,
        unquote(encode_name)(c3)::16,
        unquote(encode_name)(c4)::16
      >>
    )
  end

  def unquote(encode_name)(<<c1::10, c2::10, c3::10, c4::2>>, acc) do
    <<
      acc::binary,
      unquote(encode_name)(c1)::16,
      unquote(encode_name)(c2)::16,
      unquote(encode_name)(c3)::16,
      c4 |> bsl(3) |> unquote(encode_name)() |> band(0x00FF)::8
    >>
  end

  def unquote(encode_name)(<<c1::10, c2::10, c3::4>>, acc) do
    <<
      acc::binary,
      unquote(encode_name)(c1)::16,
      unquote(encode_name)(c2)::16,
      c3 |> bsl(1) |> unquote(encode_name)() |> band(0x00FF)::8
    >>
  end

  def unquote(encode_name)(<<c1::10, c2::6>>, acc) do
    <<
      acc::binary,
      unquote(encode_name)(c1)::16,
      c2 |> bsl(4) |> unquote(encode_name)()::16
    >>
  end

  def unquote(encode_name)(<<c1::8>>, acc) do
    <<acc::binary, c1 |> bsl(2) |> unquote(encode_name)()::16>>
  end

  def unquote(encode_name)(<<>>, acc) do
    acc
  end

  # Nimiq base 32 decoding

  upper = Enum.with_index(@nimiq_alphabet)

  to_decode_list = fn alphabet ->
    alphabet = Enum.sort(alphabet)
    map = Map.new(alphabet)
    {min, _} = List.first(alphabet)
    {max, _} = List.last(alphabet)
    {min, Enum.map(min..max, &map[&1])}
  end

  defp bad_character!(byte) do
    raise ArgumentError,
          "non-alphabet character found: #{inspect(<<byte>>, binaries: :as_strings)} (byte #{byte})"
  end

  name = :decode32
  {min, decoded} = to_decode_list.(upper)

  def unquote(name)(char) do
    try do
      elem({unquote_splicing(decoded)}, char - unquote(min))
    rescue
      _ -> bad_character!(char)
    else
      nil -> bad_character!(char)
      char -> char
    end
  end

  def unquote(name)(<<>>, _), do: <<>>

  def unquote(name)(string, pad?) do
    segs = div(byte_size(string) + 7, 8) - 1
    <<main::size(^segs)-binary-unit(64), rest::binary>> = string

    main =
      for <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8, c8::8 <- main>>, into: <<>> do
        <<
          unquote(name)(c1)::5,
          unquote(name)(c2)::5,
          unquote(name)(c3)::5,
          unquote(name)(c4)::5,
          unquote(name)(c5)::5,
          unquote(name)(c6)::5,
          unquote(name)(c7)::5,
          unquote(name)(c8)::5
        >>
      end

    case rest do
      <<c1::8, c2::8, ?=, ?=, ?=, ?=, ?=, ?=>> ->
        <<main::bits, unquote(name)(c1)::5, bsr(unquote(name)(c2), 2)::3>>

      <<c1::8, c2::8, c3::8, c4::8, ?=, ?=, ?=, ?=>> ->
        <<
          main::bits,
          unquote(name)(c1)::5,
          unquote(name)(c2)::5,
          unquote(name)(c3)::5,
          bsr(unquote(name)(c4), 4)::1
        >>

      <<c1::8, c2::8, c3::8, c4::8, c5::8, ?=, ?=, ?=>> ->
        <<
          main::bits,
          unquote(name)(c1)::5,
          unquote(name)(c2)::5,
          unquote(name)(c3)::5,
          unquote(name)(c4)::5,
          bsr(unquote(name)(c5), 1)::4
        >>

      <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8, ?=>> ->
        <<
          main::bits,
          unquote(name)(c1)::5,
          unquote(name)(c2)::5,
          unquote(name)(c3)::5,
          unquote(name)(c4)::5,
          unquote(name)(c5)::5,
          unquote(name)(c6)::5,
          bsr(unquote(name)(c7), 3)::2
        >>

      <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8, c8::8>> ->
        <<
          main::bits,
          unquote(name)(c1)::5,
          unquote(name)(c2)::5,
          unquote(name)(c3)::5,
          unquote(name)(c4)::5,
          unquote(name)(c5)::5,
          unquote(name)(c6)::5,
          unquote(name)(c7)::5,
          unquote(name)(c8)::5
        >>

      <<c1::8, c2::8>> when not pad? ->
        <<main::bits, unquote(name)(c1)::5, bsr(unquote(name)(c2), 2)::3>>

      <<c1::8, c2::8, c3::8, c4::8>> when not pad? ->
        <<
          main::bits,
          unquote(name)(c1)::5,
          unquote(name)(c2)::5,
          unquote(name)(c3)::5,
          bsr(unquote(name)(c4), 4)::1
        >>

      <<c1::8, c2::8, c3::8, c4::8, c5::8>> when not pad? ->
        <<
          main::bits,
          unquote(name)(c1)::5,
          unquote(name)(c2)::5,
          unquote(name)(c3)::5,
          unquote(name)(c4)::5,
          bsr(unquote(name)(c5), 1)::4
        >>

      <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8>> when not pad? ->
        <<
          main::bits,
          unquote(name)(c1)::5,
          unquote(name)(c2)::5,
          unquote(name)(c3)::5,
          unquote(name)(c4)::5,
          unquote(name)(c5)::5,
          unquote(name)(c6)::5,
          bsr(unquote(name)(c7), 3)::2
        >>

      _ ->
        raise ArgumentError, "incorrect padding"
    end
  end
end

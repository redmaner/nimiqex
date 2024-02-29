defmodule NimiqexTest do
  use ExUnit.Case

  test "decode_from_stake_data" do
    assert Nimiqex.Address.decode_recipient_data("0669946339e1bbd954f7ff2ddaca04aa972a1b3c36") ==
             {:ok, :ADD_STAKE, "NQ98 D6A6 6EF1 PFCM 9VYY 5PDC L15A JUM1 NF1N"}

    assert Nimiqex.Address.decode_recipient_data("0693ef3e945f99cf643f26a258a28832f898eda496") ==
             {:ok, :ADD_STAKE, "NQ61 JFPK V52Y K77N 8FR6 L9CA 521J Y2CE T94N"}
  end
end

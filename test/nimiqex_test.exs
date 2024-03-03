defmodule NimiqexTest do
  use ExUnit.Case

  test "decode_from_stake_data" do
    assert Nimiqex.Address.decode_recipient_data("0669946339e1bbd954f7ff2ddaca04aa972a1b3c36") ==
             {:ok, :ADD_STAKE, "NQ98 D6A6 6EF1 PFCM 9VYY 5PDC L15A JUM1 NF1N"}

    assert Nimiqex.Address.decode_recipient_data("0693ef3e945f99cf643f26a258a28832f898eda496") ==
             {:ok, :ADD_STAKE, "NQ61 JFPK V52Y K77N 8FR6 L9CA 521J Y2CE T94N"}
  end

  test "decode address from proof" do
    proof = "00b1881f7b5412d456a9acb7d9021d3b032686608c407b487ff377d07cd9fbf24400ffe7820c2b03abd50dd84099385791eafe26530d7dc89764c64ae962c9d63e3be40e929e0e6e022727c8a2fd19afaa4a02a4e529e71fd5b0d9be363207393804"

    assert Nimiqex.Address.extract_address_from_transaction_proof(proof) == "NQ65 DHN8 4BSR 5YSX FC3V BB5J GKM2 GB2L H17C"
  end
end

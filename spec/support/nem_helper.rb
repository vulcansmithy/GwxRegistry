module NemHelper
  def mock_nem_service
    accounts = [
      {
        :priv_key => "14201c708e0e4889e055a2419cd1871cefb57764044516898c3f7522f21c5d71",
        :pub_key => "f3e674f1095cc8e77aa9a5dd0025bc10abc80a3545b4218a25ac46ae8e5d08b2",
        :address => "TBPH46A7NYAFBXJX7I7UPVZMCPWWM5TQ2PLCTVJ3"
      },
      {
        :priv_key=>"2ffe982993ee8d49e314ed82054d01e376b9b6fa635a749823b1c8d76a80b7bd",
        :pub_key=>"52da8e42841ae346275198212ccb2412f8921302fc34496ad2872e4586b56b19",
        :address=>"TDTXOG44DG4GU5CHYNKK755OZACT5KYSFWWDZWCH"
      },
      {
        :priv_key=>"71ff881a30ecaa11087a7251749fa29f20c1f455406e9816ec34327f0c578827",
        :pub_key=>"9ddfd225889113ce07fb2cd96d5273a7cb994461214ca877fb662d1df9c8b700",
        :address=>"TBAZYU2FEF7G6FSWXPXRU35F5MFWNCBDP4AWCRQ5"
      }
    ]
    allow(NemService).to receive(:create_account).and_return(
      accounts[0]
    )
  end
end

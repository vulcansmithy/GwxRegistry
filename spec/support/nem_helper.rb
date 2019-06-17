module NemHelper
  def mock_nem_service
    allow(NemService).to receive(:create_account).and_return(
      {
        :priv_key=>"daaaf83d98ad001837f74e1c35faa130b3e9b9a5c8391bc6a3c3acf897acc259",
        :pub_key=>"0dfd390d88d8a26031220f93d674bf93cf87b5733226d69756a4914de8c0cea6",
        :address=>"TAALQOKHFCSJA76WJHUU653YCBBO6MKLMPOO43QB"
      }
    )
  end
end

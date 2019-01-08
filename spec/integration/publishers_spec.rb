require "swagger_helper"

describe "Gameworks Registry API" do

  path "/api/v1/publishers" do

    get "Retrieve all Publisher accounts" do
      tags        "Publishers"
      description "Retrieve all publisher accounts."
      produces    "application/json"

      response "200", "publisher(s) found." do
       
        examples "application/json" => {
          "data" => {
              "id" => "1",
            "type" => "publisher",
            "attributes" => {
              # @TODO 
            }
          }
        }

        run_test!
      end
    end
  end
  
end
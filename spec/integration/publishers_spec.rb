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
            "user_id" => "1",
            "type"    => "publisher",
            "attributes" => {
              # @TODO implement the attributes to be returned
            }
          }
        }
        
        # @TODO implement the schema

        run_test!
      end
    end
  end
  
  path "/api/v1/publishers/{:user_id}" do

    get "Retrieve a specific Publisher" do
      tags        "Publishers"
      description "Retrieve a specific publisher by specifying its 'user_id'."
      produces    "application/json"
      parameter   name: :user_id, in: :path, description: "'user_id' of the publisher being retrieved", required: true, type: :string

      response "200", "publisher found." do
       
        examples "application/json" => {
          "data" => {
            "user_id" => "1",
            "type"    => "publisher",
            "attributes" => {
              # @TODO implement the attributes that would be returned
            }
          }
        }
        
        # @TODO implement the schema

        let(:user_id) { Factory.create(:publisher).user.id }
        run_test!
      end
      
      response "404", "publisher not found." do
        let(:user_id) { "invalid" }
        run_test!
      end
    end
  end
 
  path "/api/v1/publishers" do

    post "Create a Publisher account" do
      tags        "Publishers"
      description "Create a publisher account."
      consumes    "application/json", "application/xml"
      parameter   name: :publisher, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
           last_name: { type: :string },
               email: { type: :stirng },
         description: { type: :string }     
        },
        required: [ "email", "description" ]
      }

      response "201", "publisher created." do
       
        examples "application/json" => {
          "data" => {
            "user_id" => "1",
            "type"    => "publisher",
            "attributes" => {
              # @TODO implement the attributes to be returned
            }
          }
        }
        
        # @TODO implement the schema

        run_test!
      end
      
      response "400", "Bad request." do
        let(:blog) { { description: "Lorem ipsum." } }

        run_test!
      end
    end
  end
end
require "swagger_helper"

describe "Gameworks Registry API" do

  ## Publishers
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

        run_test!
      end
      
      response "404", "publisher not found." do
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
      
      response "400", "Invalid request." do
        run_test!
      end
    end
  end
  
  path "/api/v1/publishers/{:user_id}" do

    patch "Update Publisher account" do
      tags        "Publishers"
      description "Update an existing Publisher account."
      consumes    "application/json", "application/xml"
      parameter   name: :user_id,   in: :path, description: "'user_id' of the publisher being updated", required: true, type: :string
      parameter   name: :publisher, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
           last_name: { type: :string },
               email: { type: :stirng },
         description: { type: :string }     
        }
      }

      response "200", "publisher updated." do
       
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
      
      response "404", "Publisher not found." do
        run_test!
      end
    end
  end
  
  path "/api/v1/publishers/{:user_id}" do

    put "Update Publisher account" do
      tags        "Publishers"
      description "Update an existing Publisher account."
      consumes    "application/json", "application/xml"
      parameter   name: :user_id,   in: :path, description: "'user_id' of the publisher being updated", required: true, type: :string
      parameter   name: :publisher, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
           last_name: { type: :string },
               email: { type: :stirng },
         description: { type: :string }     
        }
      }

      response "200", "publisher updated." do
       
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
      
      response "404", "Publisher not found." do
        run_test!
      end
    end
  end
  

  ## Players
  path "/api/v1/player" do

    get "Retrieve all Player accounts" do
      tags        "Players"
      description "Retrieve all Player accounts."
      produces    "application/json"

      response "200", "player(s) found." do
       
        examples "application/json" => {
          "data" => {
            "user_id" => "1",
            "type"    => "player",
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
  
  path "/api/v1/players/{:user_id}" do

    get "Retrieve a specific Player" do
      tags        "Players"
      description "Retrieve a specific player by specifying its 'user_id'."
      produces    "application/json"
      parameter   name: :user_id, in: :path, description: "'user_id' of the player being retrieved", required: true, type: :string

      response "200", "player found." do
       
        examples "application/json" => {
          "data" => {
            "user_id" => "1",
            "type"    => "player",
            "attributes" => {
              # @TODO implement the attributes that would be returned
            }
          }
        }
        
        # @TODO implement the schema

        run_test!
      end
      
      response "404", "player not found." do
        run_test!
      end
    end
  end
 
  path "/api/v1/players" do

    post "Create a Player account" do
      tags        "Players"
      description "Create a player account."
      consumes    "application/json", "application/xml"
      parameter   name: :player, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
           last_name: { type: :string },
               email: { type: :stirng },
         description: { type: :string }     
        },
        required: [ "email", "description" ]
      }

      response "201", "player created." do
       
        examples "application/json" => {
          "data" => {
            "user_id" => "1",
            "type"    => "player",
            "attributes" => {
              # @TODO implement the attributes to be returned
            }
          }
        }
        
        # @TODO implement the schema

        run_test!
      end
      
      response "400", "Invalid request." do
        run_test!
      end
    end
  end
  
  path "/api/v1/players/{:user_id}" do

    patch "Update Player account" do
      tags        "Players"
      description "Update an existing Player account."
      consumes    "application/json", "application/xml"
      parameter   name: :user_id, in: :path, description: "'user_id' of the player being updated", required: true, type: :string
      parameter   name: :player,  in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
           last_name: { type: :string },
               email: { type: :stirng },
         description: { type: :string }     
        }
      }

      response "200", "player updated." do
       
        examples "application/json" => {
          "data" => {
            "user_id" => "1",
            "type"    => "player",
            "attributes" => {
              # @TODO implement the attributes to be returned
            }
          }
        }
        
        # @TODO implement the schema

        run_test!
      end
      
      response "404", "Player not found." do
        run_test!
      end
    end
  end
  
  path "/api/v1/players/{:user_id}" do

    put "Update Player account" do
      tags        "Players"
      description "Update an existing Player account."
      consumes    "application/json", "application/xml"
      parameter   name: :user_id, in: :path, description: "'user_id' of the player being updated", required: true, type: :string
      parameter   name: :player,  in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
           last_name: { type: :string },
               email: { type: :stirng },
         description: { type: :string }     
        }
      }

      response "200", "player updated." do
       
        examples "application/json" => {
          "data" => {
            "user_id" => "1",
            "type"    => "player",
            "attributes" => {
              # @TODO implement the attributes to be returned
            }
          }
        }
        
        # @TODO implement the schema

        run_test!
      end
      
      response "404", "Player not found." do
        run_test!
      end
    end
  end
end
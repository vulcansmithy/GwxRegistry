require "swagger_helper"

describe "Gameworks Registry API" do

###
  ## Users
  # GET /users
  path "/users" do

    get "Retrieve all User accounts" do
      tags        "Users"
      description "Retrieve all User accounts."
      produces    "application/json"

      response "200", "user(s) found." do
       
        examples "application/json" => {
          "data" => [
                  {
                          "id" => "147",
                        "type" => "user",
                  "attributes" => {
                                  "id" => 147,
                          "first_name" => "Ismael",
                           "last_name" => "Koss",
                               "email" => "ismael.koss@example.com",
                      "wallet_address" => nil
                  }
              },
                  {
                          "id" => "148",
                        "type" => "user",
                  "attributes" => {
                                  "id" => 148,
                          "first_name" => "Shenika",
                           "last_name" => "Halvorson",
                               "email" => "shenika.halvorson@example.com",
                      "wallet_address" => nil
                  }
              },
                  {
                          "id" => "149",
                        "type" => "user",
                  "attributes" => {
                                  "id" => 149,
                          "first_name" => "Shara",
                           "last_name" => "Roob",
                               "email" => "shara.roob@example.com",
                      "wallet_address" => nil
                  }
              },
                  {
                          "id" => "150",
                        "type" => "user",
                  "attributes" => {
                                  "id" => 150,
                          "first_name" => "Devon",
                           "last_name" => "Abbott",
                               "email" => "devon.abbott@example.com",
                      "wallet_address" => nil
                  }
              },
                  {
                          "id" => "151",
                        "type" => "user",
                  "attributes" => {
                                  "id" => 151,
                          "first_name" => "Milissa",
                           "last_name" => "Dicki",
                               "email" => "milissa.dicki@example.com",
                      "wallet_address" => nil
                  }
              }
          ]
        }
        
        # @TODO implement the schema

        run_test!
      end
    end
  end
  
  # GET /users/:id
  path "/users/{:id}" do

    get "Retrieve a specific User" do
      tags        "Users"
      description "Retrieve a specific user by specifying its 'id'."
      produces    "application/json"
      parameter   name: :id, in: :path, description: "'id' of the user being retrieved", required: true, type: :string

      response "200", "user found." do
       
        examples "application/json" => {
        	"data" => {
                        "id" => "48",
                      "type" => "user",
                "attributes" => {
                                "id" => 48,
                        "first_name" => "Luisa",
                         "last_name" => "Osinski",
                             "email" => "luisa.osinski@example.com",
                    "wallet_address" => nil
                }
            }
        }
        
        # @TODO implement the schema

        run_test!
      end
      
      response "404", "user not found." do
        run_test!
      end
    end
  end
 
  # POST /users
  path "/users" do

    post "Create a User account" do
      tags        "Users"
      description "Create a user account."
      consumes    "application/json", "application/xml"
      parameter   name: :user, in: :body, schema: {
        type: :object,
        properties: {
                     first_name: { type: :string },
                      last_name: { type: :string },
                          email: { type: :string },
                       password: { type: :string }, 
          password_confirmation: { type: :string },     
        },
        required: [ "email", "password", "password_confirmation" ]
      }

      response "201", "user created." do
       
        examples "application/json" => {
          "data" => {
                     "id" => "158",
                   "type" => "user",
             "attributes" => {
                             "id" => 158,
                     "first_name" => "Mohammed",
                      "last_name" => "Graham",
                          "email" => "mohammed.graham@example.com",
                 "wallet_address" => nil
             }
          }
        }
        
        # @TODO implement the schema

        run_test!
      end
      
      response "400", "Unable to create a new User. Bad request." do
        run_test!
      end
    end
  end
  
  # PATCH /users/profile_update/:id
  path "/users/profile_update/{:id}" do
  
    patch "Update profile" do
      tags        "Users"
      description "Update an existing User profile."
      consumes    "application/json", "application/xml"
      parameter   name: :id,   in: :path, description: "'id' of the user profile being updated", required: true, type: :string
      parameter   name: :user, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
           last_name: { type: :string }
        }
      }
  
      response "200", "user updated." do
     
        examples "application/json" => {
          "data" => {
                     "id" => "375",
                   "type" => "user",
             "attributes" => {
                             "id" => 375,
                     "first_name" => "Lesley",
                      "last_name" => "Reichert",
                          "email" => "latasha.harris@example.com",
                 "wallet_address" => nil
             }
          }
        }
      
        # @TODO implement the schema
  
        run_test!
      end
    
      response "404", "User not found." do
        run_test!
      end
  
      response "400", "Unable to update user profile." do
        run_test!
      end
    end
  end
 
  # PUT /users/profile_update/:id
  path "/users/profile_update/{:id}" do
  
    put "Update profile" do
      tags        "Users"
      description "Update an existing User profile."
      consumes    "application/json", "application/xml"
      parameter   name: :id,   in: :path, description: "'id' of the user profile being updated", required: true, type: :string
      parameter   name: :user, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
           last_name: { type: :string }
        }
      }
  
      response "200", "user updated." do
     
        examples "application/json" => {
          "data" => {
                     "id" => "245",
                   "type" => "user",
             "attributes" => {
                             "id" => 245,
                     "first_name" => "Chi",
                      "last_name" => "Sipes",
                          "email" => "mason.mcclure@example.com",
                 "wallet_address" => nil
             }
          }
        }
      
        # @TODO implement the schema
  
        run_test!
      end
    
      response "404", "User not found." do
        run_test!
      end
  
      response "400", "Unable to update user profile." do
        run_test!
      end
    end
  end
### 
      
=begin
  ## Publishers
  path "/publishers" do

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
  
  path "/publishers/{:user_id}" do

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
 
  path "/publishers" do

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
  
  path "/publishers/{:user_id}" do

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
  
  path "/publishers/{:user_id}" do

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
=end    
  

  ## Players
  # GET /players
  path "/player" do

    get "Retrieve all Player accounts" do
      tags        "Players"
      description "Retrieve all Player accounts."
      produces    "application/json"

      response "200", "player(s) found." do
       
        examples "application/json" => {
            "data" => [
                    {
                            "id" => "65",
                          "type" => "player",
                    "attributes" => {
                                    "id" => 65,
                              "username" => "Morgan Dicki",
                        "wallet_address" => "90445621618164879000",
                               "user_id" => 695
                    }
                },
                    {
                            "id" => "66",
                          "type" => "player",
                    "attributes" => {
                                    "id" => 66,
                              "username" => "Erna Carroll IV",
                        "wallet_address" => "97002651083318758593",
                               "user_id" => 696
                    }
                },
                    {
                            "id" => "67",
                          "type" => "player",
                    "attributes" => {
                                    "id" => 67,
                              "username" => "Amos Wuckert",
                        "wallet_address" => "23459906457174736851",
                               "user_id" => 697
                    }
                },
                    {
                            "id" => "68",
                          "type" => "player",
                    "attributes" => {
                                    "id" => 68,
                              "username" => "Risa Prohaska",
                        "wallet_address" => "22019013962398419102",
                               "user_id" => 698
                    }
                },
                    {
                            "id" => "69",
                          "type" => "player",
                    "attributes" => {
                                    "id" => 69,
                              "username" => "Trudie Ziemann",
                        "wallet_address" => "16622347443976403018",
                               "user_id" => 699
                    }
                }
            ]
        }
        
        
        # @TODO implement the schema

        run_test!
      end
    end
  end
  
  path "/players/{:user_id}" do

    get "Retrieve a specific Player" do
      tags        "Players"
      description "Retrieve a specific player by specifying its 'user_id'."
      produces    "application/json"
      parameter   name: :user_id, in: :path, description: "'user_id' of the player being retrieved", required: true, type: :string

      response "200", "player found." do
       
        examples "application/json" => {
              "data" => {
                          "id" => "230",
                        "type" => "player",
                  "attributes" => {
                                  "id" => 230,
                            "username" => "Olive Kovacek",
                      "wallet_address" => "27468432186301453222",
                             "user_id" => 860
                  }
              }
          }

        run_test!
      end
      
      response "404", "player not found." do
        run_test!
      end
    end
  end
 
=begin 
  path "/players" do

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
                     password: { type: :string },
        password_confirmation: { type: :string },     
        },
        required: [ "email", "password", "password_confirmation" ]
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
      
      response "400", "Unable to create a new User. Bad Request." do
        run_test!
      end
    end
  end
=end
    
  path "/players/{:user_id}" do

    patch "Update Player account" do
      tags        "Players"
      description "Update an existing Player account."
      consumes    "application/json", "application/xml"
      parameter   name: :user_id, in: :path, description: "'user_id' of the player being updated", required: true, type: :string
      parameter   name: :player,  in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string },
        }
      }

      response "200", "player updated." do
       
        examples "application/json" => {
              "data" => {
                          "id" => "309",
                        "type" => "player",
                  "attributes" => {
                                  "id" => 309,
                            "username" => "leeroy.jenkins",
                      "wallet_address" => "47712730402019423195",
                             "user_id" => 939
                  }
              }
          }
        
        run_test!
      end
      
      response "404", "Player not found." do
        run_test!
      end
    end
  end
  
  path "/players/{:user_id}" do

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
                          "id" => "398",
                        "type" => "player",
                  "attributes" => {
                                  "id" => 398,
                            "username" => "PROUDCLOUD",
                      "wallet_address" => "09123f1997fc2acbc5748e311aa362696578140f074ef6ba57ea48cce5f6e250",
                             "user_id" => 1037
                  }
              }
          }
        
        run_test!
      end
      
      response "404", "Player not found." do
        run_test!
      end
    end
  end
  
end
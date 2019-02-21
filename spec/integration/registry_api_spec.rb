require "swagger_helper"

describe "Gameworks Registry API" do

  ## Users
  # POST /login
  path "/login" do
    post "Login" do
      tags "Users"
      description "Successfully login to api"
      consumes    "application/json", "application/xml"
      parameter   name: :user, in: :body, schema: {
        type: :object,
        properties: {
                email: { type: :string },
             password: { type: :string }
        },
        required: [ "email", "password" ]
      }

      response "200", "Login Successful" do
        examples "application/json" => {
          "data" =>
            {
              "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo4LCJleHAiOjE1NTA1Mzk2ODB9.Qsi7FKd-ju76sB3TqwPvqbxOLyjfCqRo1JO13G7mYLQ",
              "user": {
                  "data": {
                      "id": "8",
                      "type": "user",
                      "attributes": {
                          "id": 8,
                          "first_name": "sample",
                          "last_name": "one",
                          "email": "sample_one@gmail.com",
                          "wallet_address": "TCP33TIK2FSSFWXUIBHWXNUZDGISPTCZE5YSSTJW"
                      }
                  }
              },
              "message": "Login Successful"
            }
        }

        run_test!
      end
    end
  end

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
                      "id" => "17",
                    "type" => "user",
              "attributes" => {
                              "id" => 17,
                      "first_name" => "Duane",
                       "last_name" => "Kohler",
                           "email" => "duane.kohler@example.com",
                  "wallet_address" => "b6a86d69ff07758f3ee4a894fce8849309af74179695e3ccfb314db489a94dc8"
              }
            },
            {
                      "id" => "18",
                    "type" => "user",
              "attributes" => {
                              "id" => 18,
                      "first_name" => "Shin",
                       "last_name" => "McDermott",
                           "email" => "shin.mcdermott@example.com",
                  "wallet_address" => "f588eaf1048bc74a8c69e20e751b42d0eda50045cfd12594d363aac289ff8e78"
              }
            },
            {
                      "id" => "19",
                    "type" => "user",
              "attributes" => {
                              "id" => 19,
                      "first_name" => "Williams",
                       "last_name" => "Gaylord",
                           "email" => "williams.gaylord@example.com",
                  "wallet_address" => "92ce8f0147db4be1ae52858a530daf1f05ce8a611eef9fa5de4f6ba0d4d5f118"
              }
            },
            {
                      "id" => "20",
                    "type" => "user",
              "attributes" => {
                              "id" => 20,
                      "first_name" => "Maple",
                       "last_name" => "Schuppe",
                           "email" => "maple.schuppe@example.com",
                  "wallet_address" => "ceef5f3f9d7066ce2b5fec14559164c997a6aec2f7f6b4e8aab72d30211cf11d"
              }
            },
            {
                      "id" => "21",
                    "type" => "user",
              "attributes" => {
                              "id" => 21,
                      "first_name" => "Carylon",
                       "last_name" => "Russel",
                           "email" => "carylon.russel@example.com",
                  "wallet_address" => "71037afb5e123b65e2fc2a0666826df3bc6611b39792d14be629c9620c392a57"
              }
            }
          ]
        }

        run_test!
      end
    end
  end

  # GET /users/:id
  path "/users/{:id}" do

    get "Retrieve a specific User account" do
      tags        "Users"
      description "Retrieve a specific User account by specifying its 'id'."
      produces    "application/json"
      parameter   name: :id, in: :path, description: "'id' of the User being retrieved", required: true, type: :string

      response "200", "user found." do

        examples "application/json" => {
          "data" => {
                    "id" => "354",
                  "type" => "user",
            "attributes" => {
                            "id" => 354,
                    "first_name" => "Chuck",
                     "last_name" => "Aufderhar",
                         "email" => "chuck.aufderhar@example.com",
                "wallet_address" => "fd4a56104d30c289ae217dfa24eb4e58ca7ac4306ca69b0aee9c4652c74d0c01"
            }
          }
        }

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
                 wallet_address: { type: :string },
                       password: { type: :string },
          password_confirmation: { type: :string },
        },
        required: [ "email", "wallet_address", "password", "password_confirmation" ]
      }

      response "200", "user created." do

        examples "application/json" => {
          "data" => {
                     "id" => "158",
                   "type" => "user",
             "attributes" => {
                             "id" => 158,
                     "first_name" => "Mohammed",
                      "last_name" => "Graham",
                          "email" => "mohammed.graham@example.com",
                 "wallet_address" => "c646a0c68644fafb5eecb901104f59cbd45f26f5b1b852fde5841d75e16ce882"
             }
          }
        }

        run_test!
      end

      response "422", "Unable to create a new User account." do
        run_test!
      end
    end
  end

  # GET /confirm/:code
  path "/users/confirm/:code" do

    get "Confirm user account" do
      tags "Users"
      description "Confirm user account"
      produces "application/json"
      
      response "200", "Confirmed" do

        examples "application/json" => {
          "data" => {
                      "confirmation_code" => '1111'
                    }
        }
        
        run_test!
      end
      
      response "422", "Wrong confirmation code" do
        run_test!
      end
    end
  end

  # PATCH /users/:id
  path "/users/{:id}" do

    patch "Update a User profile" do
      tags        "Users"
      description "Update an existing User profile."
      consumes    "application/json", "application/xml"
      parameter   name: :id,   in: :path, description: "'id' of the User profile being updated", required: true, type: :string
      parameter   name: :user, in: :body, schema: {
        type: :object,
        properties: {
               first_name: { type: :string },
                last_name: { type: :string },
                       pk: { type: :string },
           wallet_address: { type: :string }
        },
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
                 "wallet_address" => "586171e81886c41bcff7223ab38bd21dfc60b425bd67f8d1a9cb26f1ccd9e43f"
             }
          }
        }

        # @TODO implement the schema

        run_test!
      end

      response "404", "User not found." do
        run_test!
      end

      response "422", "Unable to update user profile." do
        run_test!
      end
    end
  end

  # PUT /users/:id
  path "/users/{:id}" do

    put "Update a User profile" do
      tags        "Users"
      description "Update an existing User profile."
      consumes    "application/json", "application/xml"
      parameter   name: :id,   in: :path, description: "'id' of the User profile being updated", required: true, type: :string
      parameter   name: :user, in: :body, schema: {
        type: :object,
        properties: {
               first_name: { type: :string },
                last_name: { type: :string },
                       pk: { type: :string },
           wallet_address: { type: :string }
        },
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
                 "wallet_address" => "586171e81886c41bcff7223ab38bd21dfc60b425bd67f8d1a9cb26f1ccd9e43f"
             }
          }
        }

        # @TODO implement the schema

        run_test!
      end

      response "404", "User not found." do
        run_test!
      end

      response "422", "Unable to update user profile." do
        run_test!
      end
    end
  end

 ## Publishers
  path "/publishers" do

   get "Retrieve all Publisher accounts" do
     tags        "Publishers"
    description "Retrieve all publisher accounts."
    produces    "application/json"

    response "200", "publisher(s) found." do

      examples "application/json" => {
        "data" => [
                    {
                                "id" => "16",
                              "type" => "publisher",
                        "attributes" => {
                                        "id" => 16,
                            "publisher_name" => "Clemente Rosenbaum",
                               "description" => "Labore atque cumque repudiandae.",
                            "wallet_address" => "3ea0329ca47cfaddffc470637543dfa365ad3efa8a8eb69d82b0d1d994e1fc7c",
                                   "user_id" => 17
                      }
                    },
                    {
                              "id" => "17",
                            "type" => "publisher",
                      "attributes" => {
                                      "id" => 17,
                          "publisher_name" => "Janean Sporer",
                             "description" => "Eaque ut doloremque sit.",
                          "wallet_address" => "65622dfe102a4ee9a30584008b1130814d525521d96f355824b9a02791e12c89",
                                 "user_id" => 18
                        }
                    },
                    {
                                "id" => "18",
                              "type" => "publisher",
                        "attributes" => {
                                        "id" => 18,
                            "publisher_name" => "Kent Monahan II",
                               "description" => "Autem aut mollitia eum.",
                            "wallet_address" => "6c74a6311f38eadd4302e12869eccc9e2363aed4955156c735cb687e58c2d42e",
                                   "user_id" => 19
                        }
                    },
                    {
                                "id" => "19",
                              "type" => "publisher",
                        "attributes" => {
                                        "id" => 19,
                            "publisher_name" => "Thurman Maggio",
                               "description" => "Repellendus sit magni nisi.",
                            "wallet_address" => "c1f740400f0a90dec1cd99dcc25b0c27c3cbb15eb85e54a1d344f7af3aab4779",
                                   "user_id" => 20
                        }
                    },
                    {
                              "id" => "20",
                            "type" => "publisher",
                      "attributes" => {
                                      "id" => 20,
                          "publisher_name" => "Sidney Murray",
                             "description" => "Iste aut praesentium nostrum.",
                          "wallet_address" => "fa4383f66b93aa438b91a2cd82e402797b67c07c4ef0b5b38c954b5231dcbcdf",
                                 "user_id" => 21
                    }
                }
            ]
      }

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
                    "id" => "29",
                  "type" => "publisher",
            "attributes" => {
                            "id" => 29,
                "publisher_name" => "Vania Hilll",
                   "description" => "Commodi odit doloremque non.",
                "wallet_address" => "7d46d75765a50ce5e96b646b14759dc58473c23248a615a7e89a8d55867e041e",
                       "user_id" => 30
            }
        }
      }

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
               user_id: { type: :string },
        wallet_address: { type: :string },
        publisher_name: { type: :string },
           description: { type: :string }
      },
      required: [ "user_id", "publisher_name", "description" ]
    }

    response "201", "publisher created." do

      examples "application/json" => {
        "data" => {
                    "id" => "47",
                  "type" => "publisher",
            "attributes" => {
                            "id" => 47,
                "publisher_name" => "PROUDCLOUD",
                   "description" => "hello",
                "wallet_address" => "23a74c34da0e74eafcbc94a101f30b95ed7b5b8d92556c216ccc66af33eebdd7",
                       "user_id" => 48
            }
        }
      }

      run_test!
    end

    response "422", "Unable to create publisher account." do
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
        user_id:        { type: :integer },
        publisher_name: { type: :string },
        description:    { type: :string }
      }
    }

    response "200", "publisher updated." do

      examples "application/json" => {
        "data" => {
                    "id" => "54",
                  "type" => "publisher",
            "attributes" => {
                            "id" => 54,
                "publisher_name" => "Testing01",
                   "description" => "Ducimus quisquam ipsam inventore.",
                "wallet_address" => "f64789142671fec9435dbe5847bd334a4baed571b1ac647d82fda152e2b645f6",
                       "user_id" => 55
            }
        }
      }


      run_test!
    end

    response "422", "Unable to update publisher account." do
      run_test!
    end
  end
end


  ## Players
  # GET /players
  path "/players" do

    get "Retrieve all Player profiles" do
      tags        "Players"
      description "Retrieve all existing Player profiles."
      produces    "application/json"

      response "200", "player(s) found." do

        examples "application/json" => {
            "data" => [
                    {
                            "id" => "621",
                          "type" => "player",
                    "attributes" => {
                               "user_id" => 1259,
                            "first_name" => "Michaela",
                             "last_name" => "Bruen",
                                 "email" => "michaela.bruen@example.com",
                              "username" => "michaela.bruen",
                        "wallet_address" => "6321a571ee1a69c8c44e72b8a4b67c74259024eb18728575984f624923682f85"
                    }
                },
                    {
                            "id" => "622",
                          "type" => "player",
                    "attributes" => {
                               "user_id" => 1260,
                            "first_name" => "Clare",
                             "last_name" => "Dietrich",
                                 "email" => "clare.dietrich@example.com",
                              "username" => "clare.dietrich",
                        "wallet_address" => "a73203391935fda8548debd8679c6bf282e634adf864f77fa0d977fa52f834a2"
                    }
                },
                    {
                            "id" => "623",
                          "type" => "player",
                    "attributes" => {
                               "user_id" => 1261,
                            "first_name" => "Cameron",
                             "last_name" => "Hermiston",
                                 "email" => "cameron.hermiston@example.com",
                              "username" => "cameron.hermiston",
                        "wallet_address" => "bbe29af33171a6cea839817589418de814e9e825dd71fcc810236d18cfeb8f06"
                    }
                },
                    {
                            "id" => "624",
                          "type" => "player",
                    "attributes" => {
                               "user_id" => 1262,
                            "first_name" => "Paz",
                             "last_name" => "Emard",
                                 "email" => "paz.emard@example.com",
                              "username" => "paz.emard",
                        "wallet_address" => "e149817318bb8c3b6fe5c9cfcc55629b006bfdc2c5796595b5e264f7272d5b32"
                    }
                },
                    {
                            "id" => "625",
                          "type" => "player",
                    "attributes" => {
                               "user_id" => 1263,
                            "first_name" => "Dian",
                             "last_name" => "Kuhn",
                                 "email" => "dian.kuhn@example.com",
                              "username" => "dian.kuhn",
                        "wallet_address" => "796e7296f80960683b10d8bc8ac3b8974fb6788a40f9073ed7c5163223280b0b"
                    }
                }
            ]
        }

        # @TODO implement the schema

        run_test!
      end
    end
  end

  # GET /players/:user_id
  path "/players/{:user_id}" do

    get "Retrieve a specific Player" do
      tags        "Players"
      description "Retrieve a specific player by specifying its 'user_id'."
      produces    "application/json"
      parameter   name: :user_id, in: :path, description: "'user_id' of the player being retrieved", required: true, type: :string

      response "200", "player found." do

        examples "application/json" => {
              "data" => {
                          "id" => "627",
                        "type" => "player",
                  "attributes" => {
                             "user_id" => 1265,
                          "first_name" => "Wyatt",
                           "last_name" => "Ullrich",
                               "email" => "wyatt.ullrich@example.com",
                            "username" => "wyatt.ullrich",
                      "wallet_address" => "8239e8047a5f2ea5e601106810948bfe9f2226f6112dab8ce764770b4f449687"
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

  # POST /players
  path "/players" do

    post "Create a Player profile" do
      tags        "Players"
      description "Create a player profile. The requirement is that a User account should be already exist."
      consumes    "application/json", "application/xml"
      parameter   name: :player, in: :body, schema: {
        type: :object,
        properties: {
           user_id: { type: :integer },
          username: { type: :string  },
        },
        required: [ "user_id", "username" ]
      }

      response "201", "player created." do

        examples "application/json" => {
            "data" => {
                        "id" => "629",
                      "type" => "player",
                "attributes" => {
                           "user_id" => 1267,
                        "first_name" => "Kenya",
                         "last_name" => "Mertz",
                             "email" => "kenya.mertz@example.com",
                          "username" => "leeroy.jenkins",
                    "wallet_address" => "578ab32461f9b4818d43b6fe758b77cc4945ccedcfd1dfdf772af15d6a8875a5"
                }
            }
        }

        run_test!
      end

      response "422", "Unable to create a new User" do
        run_test!
      end
    end
  end

  # PATCH /players/:user_id
  path "/players/{:user_id}" do

    patch "Update Player profile" do
      tags        "Players"
      description "Update an existing Player profile."
      consumes    "application/json", "application/xml"
      parameter   name: :user_id, in: :path, description: "'user_id' of the Player profile being updated", required: true, type: :string
      parameter   name: :player,  in: :body, schema: {
        type: :object,
        properties: {
          user_id: { type: :integer },
          username: { type: :string },
        }
      }

      response "200", "player updated." do

        examples "application/json" => {
          "data" => {
              "id"   => "633",
              "type" => "player",
              "attributes" => {
                       "user_id" => 1271,
                    "first_name" => "Marcellus",
                     "last_name" => "Luettgen",
                         "email" => "marcellus.luettgen@example.com",
                      "username" => "leeroy.jenkins",
                "wallet_address" => "1579d6dc85134d90b66cf82fbdc6b4f25768fb0221dd0313ae9db0f964eef1dc"
              }
          }
        }

        run_test!
      end

      response "404", "Player not found." do
        run_test!
      end

      response "422", "Unable to update player account" do
        run_test!
      end
    end
  end

  # PUT /players/:user_id
  path "/players/{:user_id}" do

    put "Update Player profile" do
      tags        "Players"
      description "Update an existing Player profile."
      consumes    "application/json", "application/xml"
      parameter   name: :user_id, in: :path, description: "'user_id' of the Player profile being updated", required: true, type: :string
      parameter   name: :player,  in: :body, schema: {
        type: :object,
        properties: {
          user_id: { type: :integer },
          username: { type: :string },
        }
      }

      response "200", "player updated." do

        examples "application/json" => {
          "data" => {
              "id"   => "633",
              "type" => "player",
              "attributes" => {
                       "user_id" => 1271,
                    "first_name" => "Marcellus",
                     "last_name" => "Luettgen",
                         "email" => "marcellus.luettgen@example.com",
                      "username" => "leeroy.jenkins",
                "wallet_address" => "1579d6dc85134d90b66cf82fbdc6b4f25768fb0221dd0313ae9db0f964eef1dc"
              }
          }
        }

        run_test!
      end

      response "404", "Player not found." do
        run_test!
      end

      response "422", "Unable to update player account" do
        run_test!
      end
    end
  end
end

require "swagger_helper"

describe "Gameworks Registry API" do
  ## OAUTH
  path "/oauth/applications" do
    post "Create Oauth application" do
      tags        "Oauth"
      description "Get authorization to access registry api"
      produces    "application/json"
      parameter   name: :token, in: :header, description: "token provided to user upon log in", required: true, type: :string
      parameter   name: :oauth,  in: :body, schema: {
        type: :object,
        properties: {
                  name: { type: :string },
          redirect_uri: { type: :string },
          confidential: { type: :string },
                scopes: { type: :string}
        }
      }

      response "200", "ok" do

        examples "application/json" => {
              "id": 19,
              "name": "testingOauth",
              "uid": "b64a513e0797763169baab1e114a253f2b979320165ffa5013b94f32a263f8f9",
              "secret": "728f82398b0f7271afcf4a35405e578794cc7c8be84d3d0caf7edf95d15bd224",
              "redirect_uri": "http://localhost:4000",
              "scopes": [],
              "confidential": true,
              "created_at": "2019-04-25T05:18:52.456Z",
              "updated_at": "2019-04-25T05:18:52.456Z",
              "owner_id": 30,
              "owner_type": "User"
        }

        run_test!
      end

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end
    end
  end

  path "/oauth/token" do
    post "Create Access Token" do
      tags        "Oauth"
      description "Request access token by providing 'client_id' and 'client_secret'"
      produces    "application/json"
      parameter   name: :token, in: :header, description: "token provided to user upon log in", required: true, type: :string
      parameter   name: :oauth,  in: :body, schema: {
        type: :object,
        properties: {
              client_id: { type: :string },
          client_secret: { type: :string },
             grant_type: { type: :string }
        }
      }

      response "200", "ok" do

        examples "application/json" => {
          "access_token": "3fa138e6c43bfed999a320d5acf1c80a5c891ac60f5086bbababd294b3804337",
          "token_type": "Bearer",
          "expires_in": 7200,
          "created_at": 1556167217
        }

        run_test!
      end

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end
    end
  end

  ## Auth
  # POST /auth/register
  path "/auth/register" do

    post "Create a User account" do
      tags        "Auth"
      description "Create a user account."
      consumes    "application/json", "application/xml"
      parameter   name: :user, in: :body, schema: {
        type: :object,
        properties: {
                     firstName: { type: :string },
                      lastName: { type: :string },
                         email: { type: :string },
                      password: { type: :string },
          passwordConfirmation: { type: :string },
        },
        required: [ "email", "walletAddress", "password", "passwordConfirmation" ]
      }

      response "200", "user created." do

        examples "application/json" => {
          "data" => {
                     "id" => "158",
                   "type" => "user",
             "attributes" => {
                             "id" => 158,
                     "firstName" => "Mohammed",
                      "lastName" => "Graham",
                          "email" => "mohammed.graham@example.com",
                 "walletAddress" => "c646a0c68644fafb5eecb901104f59cbd45f26f5b1b852fde5841d75e16ce882"
             }
          }
        }

        run_test!
      end

      response "422", "Unable to create user account." do
        run_test!
      end

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end
    end
  end

  # POST /auth/login
  path "/auth/login" do
    post "Login" do
      tags "Auth"
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
                          "firstName": "sample",
                          "lastName": "one",
                          "email": "sample_one@gmail.com",
                          "walletAddress": "TCP33TIK2FSSFWXUIBHWXNUZDGISPTCZE5YSSTJW"
                      }
                  }
              },
              "message": "Login Successful"
            }
        }

        run_test!

        response "401", "Invalid Credentials" do
          run_test!
        end
      end
    end
  end

  # GET /auth/confirm/:code
  path "/auth/confirm/{code}" do

    post "Confirm user account" do
      tags "Auth"
      description "Confirm user account"
      produces "application/json"
      parameter   name: :code,   in: :path, description: "confirmation code sent on email", required: true, type: :string
      parameter name: :authorizationjwt, in: :header, description: "JWT Authorization Token provided to user upon log in", required: true, type: :string

      response "200", "Confirmed" do

        examples "application/json" => {
          "data" => {
                      "confirmationCode" => '1111'
                    }
        }

        run_test!
      end

      response "422", "Wrong confirmation code" do
        run_test!
      end
    end
  end

  # GET /auth/resend
  path "/auth/resend" do

    get "Resend code" do
      tags "Auth"
      description "Resend code"
      produces    "application/json"
      parameter   name: :id,   in: :path, description: "id", required: true, type: :integer
      parameter   name: :authorizationjwt, in: :header, description: "token provided to user upon log in", required: true, type: :string

      response "200", "Sent" do
        run_test!
      end
    end
  end

  # GET /auth/me
  path "/auth/me" do
    get "Retrieve a specific User account" do
      tags        "Auth"
      description "Retrieve a specific User account by specifying its 'id'."
      produces    "application/json"
      parameter   name: :id, in: :path, description: "'id' of the User being retrieved", required: true, type: :integer
      parameter   name: :authorizationjwt, in: :header, description: "token provided to user upon log in", required: true, type: :string

      response "200", "user found." do

        examples "application/json" => {
          "data" => {
                    "id" => "354",
                  "type" => "user",
            "attributes" => {
                            "id" => 354,
                    "firstName" => "Chuck",
                     "lastName" => "Aufderhar",
                         "email" => "chuck.aufderhar@example.com",
                "walletAddress" => "fd4a56104d30c289ae217dfa24eb4e58ca7ac4306ca69b0aee9c4652c74d0c01"
            }
          }
        }

        run_test!
      end

      response "404", "User not found" do
        run_test!
      end

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end
    end
  end

  # PUT /auth/me
  path "/auth/me" do

    put "Update a User profile" do
      tags        "Auth"
      description "Update an existing User profile."
      consumes    "application/json", "application/xml"
      parameter   name: :id,   in: :path, description: "'id' of the User profile being updated", required: true, type: :integer
      parameter   name: :user, in: :body, schema: {
        type: :object,
        properties: {
               firstName: { type: :string },
                lastName: { type: :string },
                       pk: { type: :string },
           walletAddress: { type: :string }
        },
      }
      parameter name: :authorizationjwt, in: :header, description: "token provided to user upon log in", required: true, type: :string

      response "200", "user updated." do

        examples "application/json" => {
          "data" => {
                     "id" => "375",
                   "type" => "user",
             "attributes" => {
                             "id" => 375,
                     "firstName" => "Lesley",
                      "lastName" => "Reichert",
                          "email" => "latasha.harris@example.com",
                 "walletAddress" => "586171e81886c41bcff7223ab38bd21dfc60b425bd67f8d1a9cb26f1ccd9e43f"
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

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end
    end
  end

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
  path "/users/{id}" do

    get "Retrieve a specific User account" do
      tags        "Users"
      description "Retrieve a specific User account by specifying its 'id'."
      produces    "application/json"
      parameter   name: :id, in: :path, description: "'id' of the User being retrieved", required: true, type: :integer

      response "200", "user found." do

        examples "application/json" => {
          "data" => {
                    "id" => "354",
                  "type" => "user",
            "attributes" => {
                            "id" => 354,
                    "firstName" => "Chuck",
                     "lastName" => "Aufderhar",
                         "email" => "chuck.aufderhar@example.com",
                "walletAddress" => "fd4a56104d30c289ae217dfa24eb4e58ca7ac4306ca69b0aee9c4652c74d0c01"
            }
          }
        }

        run_test!
      end

      response "404", "User not found" do
        run_test!
      end
    end
  end

  ## Publishers
  path "/publishers" do
    post "Create a Publisher account" do
      tags        "Publishers"
      description "Create a publisher account."
      consumes    "application/json", "application/xml"
      parameter   name: :publisher, in: :body, schema: {
        type: :object,
        properties: {
          walletAddress: { type: :string },
          publisherName: { type: :string },
             description: { type: :string }
        },
        required: [ "userId", "publisherName", "description" ]
      }
      parameter name: :authorizationjwt, in: :header, description: "token provided to user upon log in", required: true, type: :string

      response "201", "publisher created." do

        examples "application/json" => {
          "data" => {
                      "id" => "47",
                    "type" => "publisher",
              "attributes" => {
                              "id" => 47,
                  "publisherName" => "PROUDCLOUD",
                     "description" => "hello",
                  "walletAddress" => "23a74c34da0e74eafcbc94a101f30b95ed7b5b8d92556c216ccc66af33eebdd7",
                         "userId" => 48
              }
          }
        }

        run_test!
      end

      response "422", "Unable to create publisher account." do
        run_test!
      end

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end
    end
  end

  path "/publishers/{id}" do

    get "Retrieve a specific Publisher" do
      tags        "Publishers"
      description "Retrieve a specific publisher by specifying its 'userId'."
      produces    "application/json"
      parameter   name: :id,   in: :path, description: "'id' of the User profile being retrieved", required: true, type: :integer
      parameter   name: :authorizationjwt, in: :header, description: "token provided to user upon log in", required: true, type: :string

      response "200", "publisher found." do

        examples "application/json" => {
          "data" => {
                      "id" => "29",
                    "type" => "publisher",
              "attributes" => {
                              "id" => 29,
                  "publisherName" => "Vania Hilll",
                     "description" => "Commodi odit doloremque non.",
                  "walletAddress" => "7d46d75765a50ce5e96b646b14759dc58473c23248a615a7e89a8d55867e041e",
                         "userId" => 30
              }
          }
        }

        run_test!
      end

      response "404", "publisher not found." do
        run_test!
      end

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end
    end
  end

  # PUT /publishers/me
  path "/publishers/me" do

    put "Update Publisher account" do
      tags        "Publishers"
      description "Update an existing Publisher account."
      consumes    "application/json", "application/xml"
      parameter   name: :publisher, in: :body, schema: {
        type: :object,
        properties: {
          publisherName: { type: :string },
          walletAddress: { type: :string },
          description:    { type: :string }
        }
      }
      parameter name: :authorizationjwt, in: :header, description: "token provided to user upon log in", required: true, type: :string

      response "200", "publisher updated." do

        examples "application/json" => {
          "data" => {
                      "id" => "54",
                    "type" => "publisher",
              "attributes" => {
                              "id" => 54,
                  "publisherName" => "Testing01",
                     "description" => "Ducimus quisquam ipsam inventore.",
                  "walletAddress" => "f64789142671fec9435dbe5847bd334a4baed571b1ac647d82fda152e2b645f6",
                         "userId" => 55
              }
          }
        }


        run_test!
      end

      response "422", "Unable to update publisher account." do
        run_test!
      end

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end
    end
  end

  ## Players
  # GET /players
   path "/player_profiles" do

     get "Retrieve all Player profiles" do
       tags        "Player Profile"
       description "Retrieve all existing Player profiles."
       produces    "application/json"
       parameter   name: :authorizationjwt, in: :header, description: "token provided to user upon log in", required: true, type: :string

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

         response "401", "Unauthorized: Access is denied" do
           run_test!
         end
       end
     end
   end

  # POST /player_profiles
  path "/player_profiles" do

    post "Create a Player profile" do
      tags        "Player Profile"
      description "Create a player profile. The requirement is that a User account should be already exist."
      consumes    "application/json", "application/xml"
      parameter   name: :player, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string  },
          gameId:   { type: :integer }
        },
        required: [ "username" ]
      }
      parameter   name: :authorizationjwt, in: :header, description: "token provided to user upon log in", required: true, type: :string

      response "201", "player created." do

        examples "application/json" => {
            "data" => {
                        "id" => "629",
                      "type" => "player",
                "attributes" => {
                           "userId" => 1267,
                        "firstName" => "Kenya",
                         "lastName" => "Mertz",
                             "email" => "kenya.mertz@example.com",
                          "username" => "leeroy.jenkins",
                    "walletAddress" => "578ab32461f9b4818d43b6fe758b77cc4945ccedcfd1dfdf772af15d6a8875a5"
                }
            }
        }

        run_test!
      end

      response "422", "Unable to create a new User" do
        run_test!
      end

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end
    end
  end

  # GET /player_profiles/:id
  path "/player_profiles/{id}" do

    get "Retrieve a specific public Player Profile" do
      tags        "Player Profile"
      description "Retrieve a specific player by specifying its 'id'."
      produces    "application/json"
      parameter   name: :id,   in: :path, description: "'id' of the Player profile being retrieved", required: true, type: :integer

      response "200", "player found." do

        examples "application/json" => {
              "data" => {
                          "id" => "627",
                        "type" => "player",
                  "attributes" => {
                             "userId" => 1265,
                          "firstName" => "Wyatt",
                           "lastName" => "Ullrich",
                               "email" => "wyatt.ullrich@example.com",
                            "username" => "wyatt.ullrich",
                      "walletAddress" => "8239e8047a5f2ea5e601106810948bfe9f2226f6112dab8ce764770b4f449687"
                  }
              }
          }

        run_test!
      end

      response "404", "player not found." do
        run_test!
      end

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end
    end
  end

  # PUT /player_profiles/:id
  path "/player_profiles/{id}" do

    put "Update Player profile" do
      tags        "Player Profile"
      description "Update an existing Player profile."
      consumes    "application/json", "application/xml"
      parameter   name: :id,   in: :path, description: "'id' of the User profile being retrieved", required: true, type: :integer
      parameter   name: :player,  in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string },
        }
      }
      parameter name: :authorizationjwt, in: :header, description: "token provided to user upon log in", required: true, type: :string

      response "200", "player updated." do

        examples "application/json" => {
          "data" => {
              "id"   => "633",
              "type" => "player",
              "attributes" => {
                       "userId" => 1271,
                    "firstName" => "Marcellus",
                     "lastName" => "Luettgen",
                         "email" => "marcellus.luettgen@example.com",
                      "username" => "leeroy.jenkins",
                "walletAddress" => "1579d6dc85134d90b66cf82fbdc6b4f25768fb0221dd0313ae9db0f964eef1dc"
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

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end
    end
  end

  # DELETE /player_profiles/:id
  path "/player_profiles/{id}" do

    delete "Delete Player profile" do
      tags        "Player Profile"
      description "Delete a Player profile."
      produces    "application/json"
      parameter   name: :id,   in: :path, description: "'id' of the player profile being retrieved", required: true, type: :integer
      parameter name: :authorizationjwt, in: :header, description: "token provided to user upon log in", required: true, type: :string

      response "200", "player deleted." do

        examples "application/json" => {
          "data" => {
              "id"   => "633",
              "type" => "player",
              "attributes" => {
                       "userId" => 1271,
                    "firstName" => "Marcellus",
                     "lastName" => "Luettgen",
                         "email" => "marcellus.luettgen@example.com",
                      "username" => "leeroy.jenkins",
                "walletAddress" => "1579d6dc85134d90b66cf82fbdc6b4f25768fb0221dd0313ae9db0f964eef1dc"
              }
          }
        }

        run_test!
      end

      response "404", "Player not found." do
        run_test!
      end

      response "422", "Unable to delete player profile" do
        run_test!
      end

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end
    end
  end

  # GET /player_profiles/:id/triggers
  path "/player_profiles/{id}/triggers" do

    get "Retrieve Player profile triggers" do
      tags        "Player Profile"
      description "Retrieve triggers of a Player profile."
      produces    "application/json"
      parameter   name: :id,   in: :path, description: "'id' of the player profile being retrieved", required: true, type: :integer
      parameter name: :authorizationjwt, in: :header, description: "token provided to user upon log in", required: true, type: :string

      response "200", "player deleted." do

        examples "application/json" => {
          "data" => {
              "id"   => "633",
              "type" => "player",
              "attributes" => {
                       "userId" => 1271,
                    "firstName" => "Marcellus",
                     "lastName" => "Luettgen",
                         "email" => "marcellus.luettgen@example.com",
                      "username" => "leeroy.jenkins",
                "walletAddress" => "1579d6dc85134d90b66cf82fbdc6b4f25768fb0221dd0313ae9db0f964eef1dc"
              }
          }
        }

        run_test!
      end

      response "404", "Player not found." do
        run_test!
      end

      response "422", "Unable to delete player profile" do
        run_test!
      end

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end
    end
  end

  ## WALLETS
  # GET /wallets/:wallet_address
  path "/wallets/{wallet_address}" do
    get "Retrieve a specific wallet" do
      tags        "Wallets"
      description "Retrieve a specific wallet info by specifying its 'wallet_address'."
      produces    "application/json"
      parameter   name: :wallet_address, in: :path, description: "'wallet_address' of the User being retrieved", required: true, type: :string
      parameter   name: :authorizationjwt, in: :header, description: "token provided to user upon log in", required: true, type: :string

      response "200", "ok" do

        examples "application/json" => {
              "data" => {
                      "id" => "5",
                    "type" => "wallet",
              "attributes" => {
                "wallet_address" => "TCP33TIK2FSSFWXUIBHWXNUZDGISPTCZE5YSSTJW",
                  "encrypted_pk" => "m3Nce3oc_DeV9o_kLY3TfM-nTXsh9xtmUrFxZjUclfZ6YgYNFM_Mm24-noz_wsedODhydz6btus5tjGqtfYYGsPgHq4585pOFmfkgqFriPo=",
                         "nonce" => "L6Eu_tKAcjlHG8tDZ50-__KBibgk76-x"
                }
            }
        }

        run_test!
      end
    end
  end

  path "/wallets/{wallet_address}/balance" do
    get "Retrieve the balance of a specific wallet" do
      tags        "Wallets"
      description "Retrieve the balance of a specific wallet info by specifying its 'wallet_address'."
      produces    "application/json"
      parameter   name: :wallet_address, in: :path, description: "'wallet_address' of the User being retrieved", required: true, type: :string
      parameter   name: :authorizationjwt, in: :header, description: "token provided to user upon log in", required: true, type: :string

      response "200", "ok" do

        examples "application/json" => {
                  "balance" => {
                    "xem" => 692.289674,
                    "gwx" => 99084
                  }
        }

        run_test!
      end
    end
  end

  ## GAMES
  # GET /games
  path "/games" do
    get "Retrieve all games" do
      tags  "Games"
      description "Retrieve all available games"
      produces  "application/json"
      parameter name: :authorizationjwt, in: :header, description: "JWT Authorization Token provided to user upon log in", required: true, type: :string

      response "200", "ok" do
        examples "application/json" => {
              "data": [
                  {
                      "id": "2",
                      "type": "game",
                      "attributes": {
                          "id": 2,
                          "name": "snake",
                          "description": "ajlsdkfjalksjfls"
                      },
                      "relationships": {
                          "publisher": {
                              "data": {
                                  "id": "1",
                                  "type": "publisher"
                              }
                          }
                      }
                  },
                  {
                      "id": "1",
                      "type": "game",
                      "attributes": {
                          "id": 1,
                          "name": "snake",
                          "description": "boooooo"
                      },
                      "relationships": {
                          "publisher": {
                              "data": {
                                  "id": "1",
                                  "type": "publisher"
                              }
                          }
                      }
                  }
              ]
          }

        run_test!

        response "401", "Unauthorized: Access is denied" do
          run_test!
        end
      end
    end
  end

  # POST /games
  path "/games" do
    post "Create a game" do
      tags        "Games"
      description "Create a game"
      consumes    "application/json", "application/xml"
      parameter   name: :game, in: :body, schema: {
        type: :object,
        properties: {
                 name: { type: :string },
             description: { type: :string }
        },
        required: [ "name", "description" ]
      }
      parameter name: :authorizationjwt, in: :header, description: "JWT Authorization Token provided to user upon log in", required: true, type: :string

      response "201", "publisher created." do

        examples "application/json" => {
          "data" => {
                      "id" => "47",
                    "type" => "publisher",
              "attributes" => {
                              "id" => 47,
                  "publisherName" => "PROUDCLOUD",
                     "description" => "hello",
                  "walletAddress" => "23a74c34da0e74eafcbc94a101f30b95ed7b5b8d92556c216ccc66af33eebdd7",
                         "userId" => 48
              }
          }
        }

        run_test!
      end

      response "422", "Unable to create publisher account." do
        run_test!
      end

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end
    end
  end

  # GET /games/:id
  path "/games/{id}" do
    get "Retrieve game" do
      tags  "Games"
      description "Retrieve a specific game by specifying its id"
      produces  "application/json"
      parameter name: :id, in: :path, description: "'id' of the game being retrieved", required: true, type: :integer
      parameter name: :authorizationjwt, in: :header, description: "JWT Authorization Token provided to user upon log in", required: true, type: :string

      response "200", "game found" do
        examples "application/json" => {
          "data": {
                "id": "1",
                "type": "game",
                "attributes": {
                    "id": 1,
                    "name": "snake",
                    "description": "boooooo"
                },
                "relationships": {
                    "publisher": {
                        "data": {
                            "id": "1",
                            "type": "publisher"
                        }
                    }
                }
            }
        }

        run_test!
      end

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end
    end
  end

  # PUT /games/:id
  path "/games/{id}" do
    put "Update game" do
      tags  "Games"
      description "Update game successfully"
      consumes "application/json", "application/xml"
      parameter name: :id, in: :path, description: "'id' of the game being retrieved", required: true, type: :integer
      parameter name: :game, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string }
        }
      }
      parameter name: :authorizationjwt, in: :header, description: "JWT Authorization Token provided to user upon log in", required: true, type: :string

      response "200", "game updated" do
        examples "application/json" => {
            "data": {
                "id": "1",
                "type": "game",
                "attributes": {
                    "id": 1,
                    "name": "snake",
                    "description": "boooooo"
                },
                "relationships": {
                    "publisher": {
                        "data": {
                            "id": "1",
                            "type": "publisher"
                        }
                    }
                }
            }
        }

        run_test!
      end

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end
    end
  end

  # DELETE /games/:id
  path "/games/{id}" do
    delete "Delete game" do
      tags  "Games"
      description "Delete selected game"
      produces  "application/json"
      parameter name: :id, in: :path, description: "'id' of the game being retrieved", required: true, type: :integer
      parameter name: :authorizationjwt, in: :header, description: "JWT Authorization Token provided to user upon log in", required: true, type: :string

      response "204", "" do
        examples "application/json" => {
        }

        run_test!
      end

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end
    end
  end

  # POST /games/:id/player_profiles
  path "/games/{id}/player_profiles" do

    get "Retrieve player profiles" do
      tags        "Games"
      description "Retrieve all player profiles of the selected game"
      produces    "application/json"
      parameter name: :authorization, in: :header, description: "token provided to user upon log in", required: true, type: :string

      response "200", "player profiles" do

        examples "application/json" => {
            "data" => {
                        "id" => "629",
                      "type" => "player",
                "attributes" => {
                           "userId" => 1267,
                        "firstName" => "Kenya",
                         "lastName" => "Mertz",
                             "email" => "kenya.mertz@example.com",
                          "username" => "leeroy.jenkins",
                    "walletAddress" => "578ab32461f9b4818d43b6fe758b77cc4945ccedcfd1dfdf772af15d6a8875a5"
                }
            }
        }

        run_test!
      end

      response "422", "Unable to create a new User" do
        run_test!
      end

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end
    end
  end

  ## ACTIONS
  # GET /games/:game_id/actions
  path "/games/{game_id}/actions" do
    get "Retrieve all actions" do
      tags "Actions"
      description "Retrieve all available actions"
      produces "application/json"
      parameter name: :game_id, in: :path, description: "'game_id' of the game being retrieved", required: true, type: :integer
      parameter name: :authorizationjwt, in: :header, description: "JWT Authorization Token provided to user upon log in", required: true, type: :string

      response "200", "ok" do
        examples "application/json" => {
          "data": [
                {
                    "id": "3",
                    "type": "action",
                    "attributes": {
                        "id": 3,
                        "name": "snake",
                        "description": "ajlsdkfjalksjfls",
                        "fixedAmount": 10,
                        "unitFee": 5,
                        "fixed": false,
                        "rate": true
                    },
                    "relationships": {
                        "game": {
                            "data": {
                                "id": "1",
                                "type": "game"
                            }
                        }
                    }
                }
            ]
        }

        run_test!
      end

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end
    end
  end

  # POST /games/:game_id/actions
  path "/games/{game_id}/actions" do
    post "Create action" do
      tags "Actions"
      description "Create an action for the selected game"
      consumes "application/json", "application/xml"
      parameter name: :game_id, in: :path, description: "'game_id' of the game being retrieved", required: true, type: :integer
      parameter name: :action, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string },
          fixedAmount: { type: :integer },
          unitFee: { type: :integer },
          fixed: { type: :boolean },
          rate: { type: :boolean }
        },
        required: ["name", "description", "fixedAmount", "unitFee", "fixed", "rate"]
      }
      parameter name: :authorizationjwt, in: :header, description: "JWT Authorization Token provided to user upon log in", required: true, type: :string

      response "201", "ok" do
        examples "application/json" => {
          "data": {
              "id": "3",
              "type": "action",
              "attributes": {
                  "id": 3,
                  "name": "snake",
                  "description": "ajlsdkfjalksjfls",
                  "fixedAmount": 10,
                  "unitFee": 5,
                  "fixed": false,
                  "rate": true
              },
              "relationships": {
                  "game": {
                      "data": {
                          "id": "1",
                          "type": "game"
                      }
                  }
              }
          }
        }

        run_test!
      end

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end
    end
  end

  # GET /games/:game_id/actions/:id
  path "/games/{game_id}/actions/{id}" do
    get "Retrieve action" do
      tags "Actions"
      description "Retrieve a specific action by specifying its id"
      produces "application/json"
      parameter name: :game_id, in: :path, description: "'game_id' of the game being retrieved", required: true, type: :integer
      parameter name: :id, in: :path, description: "'id' of the action being retrieved", required: true, type: :integer
      parameter name: :authorizationjwt, in: :header, description: "JWT Authorization Token provided to user upon log in", required: true, type: :string

      response "200", "action found" do
        examples "application/json" => {
            "data": {
                "id": "5",
                "type": "action",
                "attributes": {
                    "id": 5,
                    "name": "register",
                    "description": "string",
                    "fixedAmount": 0,
                    "unitFee": 0,
                    "fixed": true,
                    "rate": true
                },
                "relationships": {
                    "game": {
                        "data": {
                            "id": "7",
                            "type": "game"
                        }
                    }
                }
            }
        }

        run_test!
      end

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end

      response "404", "User not found" do
        run_test!
      end
    end
  end

  # PUT /games/:game_id/actions/:id
  path "/games/{game_id}/actions/{id}" do
    put "Update action" do
      tags "Actions"
      description "Update action successfully"
      consumes "application/json", "application/xml"
      parameter name: :game_id, in: :path, description: "'game_id' of the game being retrieved", required: true, type: :integer
      parameter name: :id, in: :path, description: "'id' of the action being retrieved", required: true, type: :integer
      parameter name: :authorizationjwt, in: :header, description: "JWT Authorization Token provided to user upon log in", required: true, type: :string
      parameter name: :action, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string },
          fixedAmount: { type: :integer },
          unitFee: { type: :integer },
          fixed: { type: :boolean },
          rate: { type: :boolean }
        }
      }

      response "200", "action updated" do
        examples "application/json" => {
          "data": {
                "id": "2",
                "type": "action",
                "attributes": {
                    "id": 2,
                    "name": "cotton candy",
                    "description": "falskdjflkasdjflkj",
                    "fixedAmount": 2,
                    "unitFee": 3,
                    "fixed": false,
                    "rate": true
                },
                "relationships": {
                    "game": {
                        "data": {
                            "id": "1",
                            "type": "game"
                        }
                    }
                }
            }
        }

        run_test!
      end

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end

      response "404", "User not found" do
        run_test!
      end
    end
  end

  # DELETE /games/:game_id/actions/:id
  path "/games/{game_id}/actions/{id}" do
    delete "Delete action" do
      tags "Actions"
      description "Delete selected action"
      parameter name: :game_id, in: :path, description: "'game_id' of the game being retrieved", required: true, type: :integer
      parameter name: :id, in: :path, description: "'id' of the action being retrieved", required: true, type: :integer
      parameter name: :authorizationjwt, in: :header, description: "JWT Authorization Token provided to user upon log in", required: true, type: :string

      response "204", "" do
        examples "application/json" => {
        }

        run_test!
      end

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end

      response "404", "User not found" do
        run_test!
      end
    end
  end

  ## TRIGGERS
  # POST /triggers
  path "/triggers" do
    post "Create trigger" do
      tags "Triggers"
      description "Create a trigger"
      consumes "application/json", "application/xml"
      parameter name: :trigger, in: :body, schema: {
        type: :object,
        properties: {
          quantity: { type: :integer },
          actionId: { type: :integer },
          playerProfileId: { type: :integer }
        },
        required: ["quantity", "actionId", "playerProfileId"]
      }
      parameter name: :authorizationjwt, in: :header, description: "JWT Authorization Token provided to user upon log in", required: true, type: :string

      response "201", "trigger created" do
        examples "application/json" => {
          "data": {
                "id": "3",
                "type": "trigger",
                "attributes": {
                    "id": 3,
                    "actionId": 3,
                    "playerProfileId": 3,
                    "createdAt": "2019-05-21 04:02:26 UTC"
                },
                "relationships": {
                    "action": {
                        "data": {
                            "id": "3",
                            "type": "action"
                        }
                    },
                    "playerProfile": {
                        "data": {
                            "id": "3",
                            "type": "playerProfile"
                        }
                    }
                }
            }
        }

        run_test!
      end

      response "422", "Unable to create a trigger." do
        run_test!
      end

      response "401", "Unauthorized: Access is denied" do
        run_test!
      end
    end
  end
end

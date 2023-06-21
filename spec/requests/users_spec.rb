require 'swagger_helper'

RSpec.describe "Users", type: :request do
  describe "User API" do
    path '/users' do
      post 'Creates a user' do
        tags 'Users'
        consumes 'application/json'
        produces "application/json"
        parameter name: :user, in: :body, schema: {
          type: :object,
          properties: {
            user:{
              type: :object,
              properties: {
                username: { type: :string },
                authentication_token: { type: :string }
              }
            }
          },
          required: [ 'username', 'authentication_token' ]
        }
  
        response '201', 'user created' do
          let! (:user) {User.create(username: 'mp', authentication_token: 'mptoken')}
          run_test!
        end
  
        response '422', 'invalid request' do
          let(:user) { { username: 'foo' } }
          run_test!
        end
      end
    end
  
  end
end

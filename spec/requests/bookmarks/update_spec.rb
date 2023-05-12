require 'rails_helper'

describe "PUT /bookmarks" do

    let! (:bookmark) {Bookmark.create(url:"https://tactes.com",title: "Tactes Solutions")}

    # create a user before the test scenarios are run
    let! (:user) {User.create(username: 'mp', authentication_token: 'mptoken')}

    scenario 'valid bookmark attributes' do
        # send put request to /bookmarks/:id
        put "/bookmarks/#{bookmark.id}", params: {
          bookmark: {
            url: 'https://fluffy.es',
            title: 'Fluffy'
          }
        }, headers: { 'X-Username': user.username, 'X-Token': user.authentication_token }
    
        # response should have HTTP Status 200 OK
        expect(response.status).to eq(200)
    
        # response should contain JSON of the updated object
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:url]).to eq('https://fluffy.es')
        expect(json[:title]).to eq('Fluffy')
    
        # The bookmark title and url should be updated
        expect(bookmark.reload.title).to eq('Fluffy')
        expect(bookmark.reload.url).to eq('https://fluffy.es')
    end

    scenario 'invalid bookmark attributes' do
        # send put request to /bookmarks/:id
        put "/bookmarks/#{bookmark.id}", params: {
          bookmark: {
            url: '',
            title: 'Fluffy'
          }
        }, headers: { 'X-Username': user.username, 'X-Token': user.authentication_token }
    
        # response should have HTTP Status 422 Unprocessable entity
        expect(response.status).to eq(422)
    
        # response should contain error message
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:url]).to eq(["can't be blank"])
    
        # The bookmark title and url remain unchanged
        expect(bookmark.reload.title).to eq('Ruby Yagi')
        expect(bookmark.reload.url).to eq('https://rubyyagi.com')
    end
end
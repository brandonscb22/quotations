require 'faraday'
require 'faraday/httpclient'
Faraday.default_adapter = :httpclient

class SimpleQuote
    def initialize(client_dni:,debtor_dni:,document_amount:,folio:,expiration_date:)
        @client_dni = client_dni
        @debtor_dni = debtor_dni
        @document_amount = document_amount
        @folio = folio
        @expiration_date = expiration_date
    end

    def send
        @url = "https://chita.cl/api/v1/pricing/simple_quote?client_dni=#{@client_dni}&debtor_dni=#{@debtor_dni}&document_amount=#{@document_amount}&folio=#{@folio}&expiration_date=#{@expiration_date}"
        conn = Faraday.new do |f|
            f.adapter :httpclient
            f.request :json
            f.response :json, content_type: "application/json"
        end
        conn.get(@url,{},{'X-Api-Key': 'UVG5jbLZxqVtsXX4nCJYKwtt'})
    end
end
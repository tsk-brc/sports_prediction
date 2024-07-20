class PredictionsController < ApplicationController
    include HTTParty
    base_uri 'http://localhost:4000'
  
    def create
      features = {
        player1_rank: params[:player1_rank],
        player2_rank: params[:player2_rank],
        player1_serve_ace: params[:player1_serve_ace],
        player2_serve_ace: params[:player2_serve_ace]
      }
      response = self.class.post('/predict', body: features.to_json, headers: { 'Content-Type' => 'application/json' })
      if response.success?
        render json: response.parsed_response
      else
        render json: { error: 'Failed to get prediction' }, status: :internal_server_error
      end
    end
  end
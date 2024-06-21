# spec/controllers/boards_controller_spec.rb
require 'rails_helper'

RSpec.describe BoardsController, type: :controller do
  let(:valid_cells) { [[0, 1, 0], [0, 1, 0], [0, 1, 0]] }
  let(:invalid_cells) { nil }
  let(:board) { Board.create(cells: valid_cells) }
  let(:game) { instance_double(Game, board: board) }

  before do
    allow(Game).to receive(:new).and_return(game)
    allow(game).to receive(:start).with(valid_cells).and_return(game)
    allow(game).to receive(:start).with(nil).and_raise(ActiveRecord::RecordInvalid.new(Board.new))  # Handle invalid cells
    allow(game).to receive(:load).with(board.id).and_return(game)
    allow(game).to receive(:next_state)
    allow(game).to receive(:state).with(anything)
    allow(game).to receive(:final_state).with(anything)
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new game and returns the board" do
        post :create, params: { cells: valid_cells }, as: :json

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
				expect(JSON.parse(response.body)["cells"]).to eq(valid_cells)
      end
    end

    context "with invalid parameters" do
      it "returns an error" do
        post :create, params: { cells: invalid_cells }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end
  end

  describe "GET #show" do
    it "returns the board's cells" do
      get :show, params: { id: board.id }, as: :json

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)).to eq(valid_cells)
    end
  end

  describe "GET #next_state" do
    it "returns the next state of the board" do
      get :next_state, params: { id: board.id }, as: :json

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)).to eq(valid_cells)
    end
  end

  describe "GET #state" do
    it "returns the state of the board after n generations" do
      get :state, params: { id: board.id, n: 5 }, as: :json

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)).to eq(valid_cells)
    end
  end

  describe "GET #final_state" do
    it "returns the final state of the board" do
      get :final_state, params: { id: board.id, attempts: 10 }, as: :json

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)).to eq(valid_cells)
    end
  end

	describe "POST #reset" do
		it "resets the game and returns the initial board state" do
      expect(game).to receive(:reset)

      post :reset, params: { id: board.id }, as: :json

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)).to eq(valid_cells)
		end
	end
end

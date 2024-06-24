class BoardsController < ApplicationController
	before_action :load_game, only: [:next_state, :state, :final_state, :reset]
	
	def create
		if params[:cells].present?
			game = Game.new.start(params[:cells])
			render json: game.board, status: :created
		else
			render json: { error: "Cells can't be blank" }, status: :unprocessable_entity
		end
	end
	
	def show
		board = Board.find(params[:id].to_i)
		render json: board.cells, status: :ok
	end
	
	def next_state
		@game.next_state
		render json: @game.board.cells, status: :ok
	end
	
	def state
		@game.state(params[:n].to_i)
		render json: @game.board.cells, status: :ok
	end
	
	def final_state
		begin
			@game.final_state(params[:attempts].to_i)
			render json: { state: @game.board.cells }, status: :ok
		rescue StandardError => e
			render json: { error: e.message, last_state: @game.board.cells }, status: :unprocessable_entity
		end
	end
	
	def reset
    @game.reset
    render json: @game.board.cells, status: :ok
  end

	private
	
	def load_game
		@game = Game.new.load(params[:id].to_i)
	end
end

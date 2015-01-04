class Api::DebtsController < ApplicationController
  def create
    debt = Debt.new(
      :amount => params[:amount],
      :description => params[:description],
      :loaner => User.where(:uuid => params[:loaner]).take,
      :collector => User.where(:uuid => params[:collector]).take
    )
    debt.save
    render json: debt.as_json, status: 201, location: api_debt_url(:id => debt.uuid)
  end
end

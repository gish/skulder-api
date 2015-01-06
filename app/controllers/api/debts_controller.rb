class Api::DebtsController < ApplicationController
  def create
    begin
      params.require(:amount)
      params.require(:description)
      params.require(:loaner)
      params.require(:collector)
    rescue => e
      render_error(
        'missing_parameter',
        "Missing parameter #{e.param}",
        403
      )
      return
    end

    loaner = User.where(:uuid => params[:loaner]).take
    collector = User.where(:uuid => params[:collector]).take

    if not loaner
      render_error(
        'loaner_missing',
        "Loaner #{params[:loaner]} doesn't exist",
        403
      )
      return
    end

    if not collector
      render_error(
        'collector_missing',
        "Collector #{params[:collector]} doesn't exist",
        403
      )
      return
    end

    debt = Debt.new(
      :amount => params[:amount],
      :description => params[:description],
      :loaner => loaner,
      :collector => collector
    )
    debt.save
    render json: debt.as_json, status: 201, location: api_debt_url(:id => debt.uuid)
  end

  def index
    loaner_uuid = params[:loaner]
    loaner = User.where(:uuid => loaner_uuid)
    debts = Debt.where(:loaner => loaner)
    render json: debts
  end
end

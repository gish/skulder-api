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
        400
      )
      return
    end

    loaner = User.where(:uuid => params[:loaner]).take
    collector = User.where(:uuid => params[:collector]).take

    if not loaner
      render_error(
        'loaner_missing',
        "Loaner #{params[:loaner]} doesn't exist",
        400
      )
      return
    end

    if not collector
      render_error(
        'collector_missing',
        "Collector #{params[:collector]} doesn't exist",
        400
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
    if params[:loaner].blank? && params[:collector].blank?
      render_error(
        'missing_collector_or_loaner',
        'At least one of collector or loaner must be passed',
        400
      ) and return
    end

    if params[:loaner]
      loaner = User.where(:uuid => params[:loaner])
    end
    if params[:collector]
      collector = User.where(:uuid => params[:collector])
    end

    if collector
      debts = Debt.where(:collector => collector)
    end

    if loaner
      debts = Debt.where(:loaner => loaner)
    end

    if collector && loaner
      debts = Debt.where(
        :collector => collector,
        :loaner => loaner
      )
    end

    render json: debts
  end
end

class SpecificallyController < ApplicationController

  def new
    @i = 0
    @number_restriction = params[:number_restrictions].to_i
    @number_variables = params[:number_variables].to_i
  end
end
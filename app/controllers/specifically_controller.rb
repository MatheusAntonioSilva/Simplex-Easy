class SpecificallyController < ApplicationController

  def new
    @i = 0
    @number_restriction = params[:number_restrictions].to_i
    @number_variables = params[:number_variables].to_i
  end

  def create

    function_objective = []
    number_variables = params[:number_variables].to_i
    number_restriction = params[:number_restrictions].to_i

    for i in 1..number_variables
      function_objective[i] = params["input_x#{i}"]
    end


    function_restrictions = []
    function_reserveds = []
    function_limits = []
    for j in 1..number_variables
      function_restrictions[j] = []
      for i in 1..number_restriction + 1
        function_restrictions[j][i] = params["restriction_x#{i}_#{j}"]
      end
        function_reserveds[j] = params["restriction_f#{i}_#{j}"]
        function_limits[j] = params["limite_x#{j}"]
    end
    puts "========================="
    puts function_objective[1]
    puts "========================="
    puts function_restrictions[1][1]
    puts "========================="
    puts function_reserveds[1]
    puts "========================="
    puts function_limits[2]
    puts "========================="
  end
end
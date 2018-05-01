class SpecificallyController < ApplicationController

  @solution = ''

  def new
    @i = 0
    @number_restriction = params[:number_restrictions].to_i
    @number_variables = params[:number_variables].to_i
  end

  def setSolution(solution)
    @solution = solution
  end
  def getSolution
    @solution
  end


  def create

    function_objective = []
    number_variables = params[:number_variables].to_i
    number_restriction = params[:number_restrictions].to_i

    for i in 0..number_variables-1
      function_objective[i] = params["input_x#{i+1}"].to_i
    end
    function_objective2 = []
    puts "=========================="
    puts function_objective
    puts function_objective.length
    function_objective.each do |value|
      puts value
    end
    puts "=========================="


    function_restrictions = []
    function_reserveds = []
    function_limits = []
    for j in 0..number_variables-1
      function_restrictions[j] = []
      for i in 0..number_restriction-1
        function_restrictions[j][i] = params["restriction_x#{i+1}_#{j+1}"].to_i
      end
        function_reserveds[j] = params["restriction_f#{i+1}_#{j+1}"].to_i
        function_limits[j] = params["limite_x#{j+1}"].to_i
    end

    puts "=========================="
    puts function_restrictions.to_s
    puts "=========================="
    puts "=========================="
    puts function_reserveds.to_s
    puts "=========================="
    puts "=========================="
    puts function_limits.to_s
    puts "=========================="
    @simplex = Simplex.new(
        function_objective,       # coefficients of objective function
        function_restrictions,
        function_limits        # .. and the rhs of the inequalities
    )

    setSolution(@simplex.solution)
    render :solution
  end

  def solution
    @solution = getSolution
    puts "============="
    puts getSolution
    puts "============="
  end

end
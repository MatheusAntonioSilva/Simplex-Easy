class SpecificallyController < ApplicationController

  @solution = ''
  @simplex = ''
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

  def setSimplex(function_objective, function_restrictions, function_limits )
    @simplex = Simplex.new(
        function_objective,       # coefficients of objective function
        function_restrictions,
        function_limits        # .. and the rhs of the inequalities
    )
    puts "==============="
    puts @simplex.solution
    puts "==============="

  end

  def getSimplex
    @simplex
  end

  def create

    function_objective = []
    @number_variables = params[:number_variables].to_i
    @number_restriction = params[:number_restrictions].to_i

    for i in 0..@number_variables-1
      function_objective[i] = params["input_x#{i+1}"].to_i
    end

    function_restrictions = []
    function_reserveds = []
    function_limits = []
    for j in 0..@number_variables-1
      function_restrictions[j] = []
      for i in 0..@number_restriction-1
        function_restrictions[j][i] = params["restriction_x#{i+1}_#{j+1}"].to_i
      end
        function_reserveds[j] = params["restriction_f#{i+1}_#{j+1}"].to_i
        function_limits[j] = params["limite_x#{j+1}"].to_i
    end


    setSimplex(function_objective, function_restrictions, function_limits )

    @solution = getSimplex.solution
    @matriz = getSimplex.matriz_tableau
    @valueZ = 0

    for i in 1..@matriz.length-1
      @valueZ = @valueZ + @matriz[i].last.to_f
    end
    @variables_reserves = []
    for i in @number_variables..@matriz[0].length-1
      @variables_reserves[i-@number_variables] = @matriz[0][i].to_f
    end
    puts "xxxxxxxxxxxxxxxxxxxxxxx"
    puts @variables_reserves
    puts "xxxxxxxxxxxxxxxxxxxxxxx"
    @valueZ
    @variables_reserves
    render :solution
  end

  def solution

  end

end
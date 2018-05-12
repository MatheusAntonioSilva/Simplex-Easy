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
  end

  def getSimplex
    @simplex
  end

  #solucão passo a passo e que renderiza e que chamará a view step(passo)
  def stepInStep(function_objective, number_variables)
    res = ''
    cont = 0
    @matrix = []
    @solution = []
    @valueZ = []
    @variables_reserves = []

    while getSimplex.can_improve? == true
      @matrix[cont] = getSimplex.matriz_tableau
      getSimplex.can_improve?
      @solution[cont] = getSimplex.pivot

      for i in 0..number_variables
        @valueZ[cont] = @valueZ[cont].to_f + @matrix[cont][0][i].to_f * function_objective[i].to_f
      end
       # for i in number_variables..@matrix[cont][0].length-1
       #   @variables_reserves[cont] = [i-number_variables]
       #   @variables_reserves[cont][i-number_variables] = @matrix[cont][0][i].to_f
       # end
      cont = cont + 1
    end
    @solution_end = getSimplex.solution
    @matriz_end = getSimplex.matriz_tableau
    @valueZ_end = 0
    @variables_reserves_end = []


    for i in 0..@solution_end.length
      @valueZ_end = @valueZ_end + @solution_end[i].to_f * function_objective[i].to_f
    end
    for i in number_variables..@matriz_end[0].length-1
      @variables_reserves_end[i-number_variables] = @matriz_end[0][i].to_f
    end

    render :step
  end

  #local onde é recebido o que o usuario digitou de variaveis e restrições
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

    #se o usuario escolheu passo a passo vai ir para o metodo step se não fara solucao direta e chamara a  view de solution
    setSimplex(function_objective, function_restrictions, function_limits )
    if(params[:option_user].to_i == 2)
      stepInStep(function_objective, @number_variables)
    else
      @solution = getSimplex.solution
      @matriz = getSimplex.matriz_tableau
      @valueZ = 0

      for i in 0..@solution.length
        @valueZ = @valueZ + @solution[i].to_f * function_objective[i].to_f
      end
      @variables_reserves = []
      for i in @number_variables..@matriz[0].length-1
        @variables_reserves[i-@number_variables] = @matriz[0][i].to_f
      end
      @valueZ
      @variables_reserves
      render :solution
    end
  end

  def solution

  end

  def step

  end

end

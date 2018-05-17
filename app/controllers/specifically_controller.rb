class SpecificallyController < ApplicationController

  @solution = ''
  @simplex = ''

  def new
    @i = 0
    @number_restriction = params[:number_restrictions].to_i
    @number_variables = params[:number_variables].to_i
    @max_or_min = params[:max_or_min]
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

  def step
    render :step
  end
  #solucão passo a passo e que renderiza e que chamará a view step(passo)
  # def stepInStep(function_objective, number_variables)
  #   res = ''
  #   cont = 0
  #   @matrix = []
  #   @solution = []
  #   @valueZ = []
  #   @variables_reserves = []
  #
  #   while getSimplex.can_improve? == true
  #     @matrix[cont] = getSimplex.matriz_tableau
  #     getSimplex.can_improve?
  #     @solution[cont] = getSimplex.pivot
  #
  #     for i in 0..number_variables
  #       @valueZ[cont] = @valueZ[cont].to_f + @matrix[cont][0][i].to_f * function_objective[i].to_f
  #     end
  #      # for i in number_variables..@matrix[cont][0].length-1
  #      #   @variables_reserves[cont] = [i-number_variables]
  #      #   @variables_reserves[cont][i-number_variables] = @matrix[cont][0][i].to_f
  #      # end
  #     cont = cont + 1
  #   end
  #   @solution_end = getSimplex.solution
  #   @matriz_end = getSimplex.matriz_tableau
  #   @valueZ_end = 0
  #   @variables_reserves_end = []
  #
  #
  #   for i in 0..@solution_end.length
  #     @valueZ_end = @valueZ_end + @solution_end[i].to_f * function_objective[i].to_f
  #   end
  #   for i in number_variables..@matriz_end[0].length-1
  #     @variables_reserves_end[i-number_variables] = @matriz_end[0][i].to_f
  #   end
  #
  #   render :step
  # end

  #local onde é recebido o que o usuario digitou de variaveis e restrições
  #

  def error
    redirect_to specifically_impracticable_error_path
  end
  def create
    function_objective = []
    @number_variables = params[:number_variables].to_i
    @number_restriction = params[:number_restrictions].to_i
    if(params[:max_or_min] ==  '1')
      for i in 0..@number_variables-1
        function_objective[i] = params["input_x#{i+1}"].to_i
      end
    else
      for i in 0..@number_variables-1
        function_objective[i] = params["input_x#{i+1}"].to_i * (-1)
      end
    end

    function_restrictions = []
    function_reserveds = []
    function_limits = []
    puts "============"

    for i in 0..@number_restriction-1
      function_restrictions[i] = []
      for j in 0..@number_variables-1
        function_restrictions[i][j] = params["restriction_x#{j+1}_#{i+1}"].to_i
      end
      function_reserveds[i] = params["restriction_f#{i+1}_#{i+1}"].to_i
      function_limits[i] = params["limite_x#{i+1}"].to_i
    end

    puts "============"
    puts function_objective.to_s
    puts function_restrictions.to_s
    puts function_limits.to_s
    puts "oi cheguei"
    puts "============"
    #se o usuario escolheu passo a passo vai ir para o metodo step se não fara solucao direta e chamara a  view de solution
    setSimplex(function_objective, function_restrictions, function_limits )

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

      for i in 0..@number_variables
        @valueZ[cont] = @valueZ[cont].to_f + @matrix[cont][0][i].to_f * function_objective[i].to_f
      end
      # for i in number_variables..@matrix[cont][0].length-1
      #   @variables_reserves[cont] = [i-number_variables]
      #   @variables_reserves[cont][i-number_variables] = @matrix[cont][0][i].to_f
      # end
      cont = cont + 1
      if (cont >= params[:interaction_limit].to_i)
        @error_solution = true
      end
    end

    @solution_end = getSimplex.solution
    @matriz_end = getSimplex.matriz_tableau
    @valueZ_end = 0
    @variables_reserves_end = []
    puts "================="
    puts getSimplex.solution
    puts "=================="
      for i in 0..@solution_end.length
        @valueZ_end = @valueZ_end + @solution_end[i].to_f * function_objective[i].to_f
      end

      for i in @number_variables..@matriz_end[0].length-1
        @variables_reserves_end[i-@number_variables] = @matriz_end[0][i].to_f
      end

      if (@error_solution)
        render :test
        else if(params[:option_user].to_i == 2)
          render :step
        else
          render :solution
         end
      end
  end

  def solution

  end

  def step

  end

  def test

  end

  def redirect_path
    redirect_to root_path
  end

end

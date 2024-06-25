defmodule Derivatives do
  @type literals() :: {:num, number()} | {:var, atom()}

  @type expr() ::
        {:add, expr(), expr()}
      | {:mul, expr(), expr()}
      | {:div, expr(), expr()}
      | {:exp, expr(), literals()}
      | {:ln, expr()}
      | {:sqrt, expr()}
      | {:sin, expr(),expr()}
      | {:cos, expr()}
      | literals()


  #For the report:

  def test_inverse_sine_expression do
    x = :x
    e = {:div, {:num, 1}, {:sin, {:mul, {:num, 2}, {:var, x}}}}
    d = derive(e, x)
    IO.puts("Expression: #{pprint(e)}")
    IO.puts("Derivative: #{pprint(d)}")
    IO.puts("Simplified: #{pprint(simplify(d))}")
  end


  def test_derivative do
    x = :x
    e = {:add, {:add, {:mul, {:num, 2}, {:exp, {:var, x}, {:num, 2}}}, {:mul, {:num, 3}, {:var, x}}}, {:num, 5}}
    d = derive(e, x)

    IO.puts("expression: #{pprint(e)}")
    IO.puts("derivative: #{pprint(d)}")
    IO.puts("Simplified: #{pprint(simplify(d))}")
  end

  def test_power_rule do
    x = :x
    e = {:exp, {:var, x}, {:num, 3}}
    d = derive(e, x)
    IO.puts("Expression: #{pprint(e)}")
    IO.puts("Derivative: #{pprint(d)}")
    IO.puts("Simplified: #{pprint(simplify(d))}")
  end

  def test_ln_rule do
    x = :x
    e = {:ln, {:var, x}}
    d = derive(e, x)
    IO.puts("Expression: #{pprint(e)}")
    IO.puts("Derivative: #{pprint(d)}")
    IO.puts("Simplified: #{pprint(simplify(d))}")
  end

  def test_inverse_rule do
    x = :x
    e = {:div, {:num, 1}, {:var, x}}
    d = derive(e, x)
    IO.puts("Expression: #{pprint(e)}")
    IO.puts("Derivative: #{pprint(d)}")
    IO.puts("Simplified: #{pprint(simplify(d))}")
  end

  def test_sqrt_rule do
    x = :x
    e = {:sqrt, {:mul, {:num, 2}, {:var, x}}}
    d = derive(e, x)
    IO.puts("Expression: #{pprint(e)}")
    IO.puts("Derivative: #{pprint(d)}")
    IO.puts("Simplified: #{pprint(simplify(d))}")
  end


  def test_sin_rule do
    x = :x
    e = {:sin, {:var, x}}
    d = derive(e, x)
    IO.puts("Expression: #{pprint(e)}")
    IO.puts("Derivative: #{pprint(d)}")
    IO.puts("Simplified: #{pprint(simplify(d))}")
  end


  def test1() do
    x = :x
    e = {:add, {:mul, {:num, 2}, {:var, x}}, {:num, 3}}
    d = derive(e, x)
    c = calc(d, :x, 5) # A calculate which calcutes the expresion when given an x
    IO.puts("expression: #{pprint(e)}")
    IO.puts("derivative: #{pprint(d)}")
    IO.puts("Simplified: #{pprint(simplify(d))}")
    IO.puts("Calculated: #{pprint(simplify(c))}")
  end

  def test2() do
    x = :x
    e = {:add,
    {:exp, {:var,x}, {:num, 3}},
    {:num,4}}

    d = derive(e, x)
    c = calc(d, :x, 5) # A calculate which calcutes the expresion when given an x
    IO.puts("expression: #{pprint(e)}")
    IO.puts("derivative: #{pprint(d)}")
    IO.puts("Simplified: #{pprint(simplify(d))}")
    IO.puts("Calculated: #{pprint(simplify(c))}")
  end


  def test_ln() do
    x = :x
    e = {:ln, {:mul, {:num,2} ,{:var, x}}}
    d = derive(e, x)
    IO.puts("expression: #{pprint(e)}")
    IO.puts("derivative: #{pprint(d)}")
    IO.puts("Simplified: #{pprint(simplify(d))}")
  end

  def test_sqrt() do
    x = :x
    e = {:sqrt, {:var, x}}
    d = derive(e, x)
    IO.puts("expression: #{pprint(e)}")
    IO.puts("derivative: #{pprint(d)}")
    IO.puts("Simplified: #{pprint(simplify(d))}")
  end

  def test_sin() do
    x = :x
    e = {:sin, {:var, x}}
    d = derive(e, x)
    IO.puts("expression: #{pprint(e)}")
    IO.puts("derivative: #{pprint(d)}")
    IO.puts("Simplified: #{pprint(simplify(d))}")
  end

  def test_division do
    x = :x
    e = {:div, {:num, 1}, {:var, x}}
    d = derive(e, x)
    IO.puts("expression: #{pprint(e)}")
    IO.puts("derivative: #{pprint(d)}")

  end
  def derive({:num, _}, _), do: {:num, 0}
  def derive({:var, v}, v), do: {:num, 1}
  def derive({:var, _}, _), do: {:num, 0}
  def derive({:add, e1, e2}, v) do {:add, derive(e1, v), derive(e2, v)} end
  def derive({:mul, e1, e2}, v) do {:add, {:mul, derive(e1, v), e2}, {:mul, e1, derive(e2, v)}}  end


  # Power rule
  def derive({:exp, {:var, x}, {:num, n}}, x) do {:mul, {:num, n}, {:exp, {:var, x}, {:num, n-1}}} end

   # lnX
   def derive({:ln, e}, v) do
    {:div, derive(e, v), e}
  end

  # sqrt
  def derive({:sqrt, e}, v) do
    {:mul, {:div, {:num, 1}, {:mul, {:num, 2}, {:sqrt, e}}}, derive(e, v)}
  end

  # sinX

  def derive({:sin, e}, v) do
    {:mul, derive(e, v), {:cos, e}}
  end

  def derive({:div, {:num, 1}, {:sin, e}}, _v) do
    {:cos, e}
  end

  # 1/x
  def derive({:div, {:num, 1}, {:var, x}}, x) when x != 0 do
    {:neg, {:div, {:num, 1}, {:exp, {:var, x}, {:num, 2}}}}
  end

  def derive({:div, {:num, 1}, {:var, _}}, _), do: {:num, 0}


  #Simplification
  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end

  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end

  def simplify({:exp, e1, e2}) do
    simplify_exp(simplify(e1), simplify(e2))
  end

  def simplify({:ln, e1}) do
    simplify_ln({:ln, simplify(e1)}) end

  def simplify({:sqrt, e1}) do
      {:sqrt, simplify(e1)}
    end



  #def simplify ({:sin, e1}) do  simplify_sin({:sin, simplify(e1)}) end

  def simplify({:neg, e1}) do
    {:neg, simplify(e1)}
  end

  def simplify(e) do e end


  def calc({:num,n},_,_) do
    {:num, n}
  end

  def calc({:var, v}, v, n) do
    {:num, n}
  end

  def calc({:var, v},_ , _) do
    {:var, v}
  end

  def calc({:add, e1, e2}, v , n) do
    {:add, calc(e1,v,n), calc(e2,v,n)}
  end

  def calc({:mul, e1, e2}, v , n) do
    {:mul, calc(e1,v,n), calc(e2,v,n)}
  end

  def calc({:exp, e1, e2}, v , n) do
    {:exp, calc(e1,v,n), calc(e2,v,n)}
  end

  def calc({:ln, e1}, v, n) do
    {:ln, calc(e1, v, n)} end


  #Private functions within simplify

  # Simplifying addition brackets
  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end

  def simplify_add({:var, v}, {:var, v}) do {:mul, {:num, 2}, {:var, v}} end
  def simplify_add(e1, e2) do {:add, e1, e2} end

  # Simplifying multiplication brackets


  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(_, {:num, 0}) do {:num, 0} end
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul(e1, {:num, 1}) do e1 end
  def simplify_mul({:var, v}, {:var, v}) do {:exp, {:var, v}, {:num, 2}} end
  def simplify_mul({:var, v}, {:exp, {:var, v}, {:num, n}}) do {:exp, {:var, v}, {:num, n+1}} end
  def simplify_mul({:exp, {:var, v}, {:num, n}}, {:var, v}) do {:exp, {:var, v}, {:num, n+1}} end

  def simplify_mul({:num, n1}, {:mul, {:num, n2}, e2}) do
    {:mul, {:num, n1*n2}, e2}
  end
  def simplify_mul({:num, n1}, {:mul, e2, {:num, n2}}) do
    {:mul, {:num, n1*n2}, e2}
  end
  def simplify_mul({:mul, {:num, n1}, e1}, {:num, n2}) do
    {:mul, {:num, n1*n2}, e1}
  end
  def simplify_mul({:mul, e1, {:num, n1}}, {:num, n2}) do
    {:mul, {:num, n1*n2}, e1}
  end

  def simplify_mul(e1, e2) do {:mul, e1, e2} end


  #Simplifying Expression

  defp simplify_exp(_, {:num, 0}), do: {:num, 1}
  defp simplify_exp(e1, {:num, 1}), do: e1
  defp simplify_exp({:num, n1}, {:num, n2}), do: {:num, :math.pow(n1,n2)}
  defp simplify_exp(e1, e2),do: {:exp, e1, e2}


  #Simplifying Ln
  defp simplify_ln({:ln, {:num, 1}}), do: {:num, 0}
  defp simplify_ln({:ln, {:num, n1}}), do: {:num, :math.log(n1)}
  defp simplify_ln(e1), do: e1



  def simplify_div({:cos, e1}, {:sin, e2}) do
    {:tan, e1, e2}
  end

  def simplify_div(e1, e2) do
    {:div, e1, e2}
  end

  #Simpliying Sin(x)
  #defp simplify_sin({:sin, e1}) do {:sin, simplify(e1)} end

  #defp simplify_sin(e1) do e1 end

  # div

  #def simplify_div({:div, e1, {:num, 1}}), do: simplify(e1)
  #def simplify_div({:div, {:num, n1}, {:num, n2}}), do: {:num, n1 / n2}
  #def simplify_div({:div, {:num, 0}, _e2}), do: {:num, 0}
  #def simplify_div({:div, e1, e2}), do: {:div, simplify(e1), simplify(e2)}

  # Pretty printing: takes expression and returns a pretty string
  def pprint(:x) do  "x" end

  def pprint({:num, n}) do
    "#{n}"
  end

  def pprint({:var, v}) do
    "#{v}"
  end

  def pprint({:add, e1, e2}) do
    "(#{pprint(e1)} + #{pprint(e2)})"
  end

  def pprint({:mul, e1, e2}) do
    "(#{pprint(e1)} * #{pprint(e2)})"
  end

  def pprint({:exp, e1, e2}) do
    "#{pprint(e1)}^#{pprint(e2)}"
  end

  def pprint({:ln, e1}) do
    "ln(#{pprint(e1)})"
  end

  def pprint({:div, e1, e2}) do
    "#{pprint(e1)} / #{pprint(e2)}"
  end

  def pprint({:sqrt, e1}) do
     "sqrt(#{pprint(e1)})"
  end

  def pprint({:sin, e1}) do
     "sin(#{pprint(e1)})"
    end

  def pprint({:cos, e1}) do
      "cos(#{pprint(e1)})"
     end

  def pprint({:neg, e1}) do
      "-#{pprint(e1)}"
    end


  end


runs = [50, 100];

%% data
r = [r1, r2, r3];  % Replace with actual returns
V = [ v11, v12, v13;
      v21, v22, v23;
      v31, v32, v33];  % Replace with actual covariance matrix
pigre = pigre_value;  % Replace with actual performance constraint value

numberOfVariables = 3;

%% GA setting
FitnessFunction = @prtf1;

Population = [5, 10, 50]; % population size
Generations = [25, 100]; % max number of generations
CrossoverFraction = [0.1, 0.8]; % probability of crossover (0.80 default)
MutationFraction = [0.01, 0.05]; % probability of mutation (0.01 default)
opts.StallGenLimit = 10; % max number of generations in case of stall [* * * * * IMPORTANT * * * * *]
penality = [0.1, 0.5];

%% GA
counter1 = 1;

for run = runs
        for popSize = Population
           for gen = Generations
               for crossoverFrac = CrossoverFraction
                   for mutationFrac = MutationFraction
                       counter1 = counter1 + 1;
                       % Imposta gli opzioni per l'algoritmo genetico
                       opts = gaoptimset;
                       opts.PopulationSize = popSize;
                       opts.Generations = gen;
                       opts.CrossoverFraction = crossoverFrac;
                       opts.MutationFraction = mutationFrac;
                       results = zeros(run, 8);

                       %% GA
                        for xx = 1:run
                            tic;
                            [x, fitness] = ga(FitnessFunction, numberOfVariables, [], [], [], [], [], [], [], opts);
                            comp_time = toc;
                            results(xx, 1:3) = x; % portfolio
                            results(xx, 4) = fitness; % fitness
                            results(xx, 5) = x * V * x'; % variance of the portfolio return
                            results(xx, 6) = r * x' - pigre; % violation of the performance constraint
                            results(xx, 7) = sum(x) - 1; % violation of the budget constraint
                            results(xx, 8) = comp_time; % computational time

                            V1 = inv(V);
                            e = ones(1, numberOfVariables);
                            alfa = r * V1 * r';
                            beta = r * V1 * e';
                            gamma = e * V1 * e';
                            NUME = (gamma * V1 * r' - beta * V1 * e') * pigre + (alfa * V1 * e' - beta * V1 * r');
                            DENO = alfa * gamma - beta^2;
                            tru_sol = NUME / DENO;
                            
                            dd = dist([x; tru_sol']');
                            results(xx, 9) = dd(2, 1);
                            [results(1, 1:3); tru_sol'];
                        end

                        %% results
                        results = sortrows(results, 4);
                        W1 = results(1, 1);
                        W2 = results(1, 2);
                        W3 = results(1, 3);
                        Fitness = results(1, 4);
                        Fitness_std = std(results(:, 4));
                        Variance_of_P = results(1, 5);
                        Performance_Violation = results(1, 6);
                        Budget_Violation = results(1, 7);
                        Computational_Time = results(1, 8);
                        Distance = results(1, 9);

                        Type = "Runs: " + run + ", Pop: " + popSize + ", Gen: " + gen + ", Cross: " + crossoverFrac + ", Mut: " + mutationFrac;

                        matrix(counter1, :) = [Type, Fitness, Fitness_std, Variance_of_P, Performance_Violation, Budget_Violation, Distance, tru_sol'];
                   end
               end
           end
        end
end

tabella = table(matrix(:, 1), matrix(:, 2), matrix(:, 3), matrix(:, 4), matrix(:, 5), matrix(:, 6), matrix(:, 7), matrix(:, 8), matrix(:, 9), matrix(:, 10), 'VariableNames', {'Type', 'Best Fitness', 'Fitness std', 'Variance_of_P', 'Performance_Violation', 'Budget_Violation', 'Distance', 'W1', 'W2', 'W3'});
filename = "Results_BestApproachga_a.xls";
writetable(tabella, filename)

%% function
function y = prtf1(x)
y = v11*(x(1)^2) + v22*(x(2)^2) + v33*(x(3)^2) + ...
    2*(v12)*x(1)*x(2) + ...
    2*(v13)*x(1)*x(3) + ...
    2*v23*x(2)*x(3) + ...
    (1 / 1)*(abs(r1*x(1) + r2*x(2) + r3*x(3) - pigre) + ...
    abs(x(1) + x(2) + x(3) - 1));
end

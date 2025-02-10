# **Genetic Algorithms (GAs) for Portfolio Selection**  

Genetic Algorithms (GAs) are **nature-inspired, iterative, population-based, evolutionary, derivative-free metaheuristic methods** used to solve global unconstrained optimization problems.  

Inspired by the principles of natural selection and genetics, GAs are widely applied to generate high-quality solutions for optimization and search problems. They simulate the process of natural selection, where each new generation, on average, inherits more "favorable genes" than the previous one, progressively improving the quality of solutions over time.  

GAs aim to find **near-optimal solutions** to global optimization problems of the following form:  

$\min_{x \in \mathbb{R}^d} \text{fitness function}(x)$  

---

## **Overview & Goals**  

This project implements a Genetic Algorithm (GA) to determine the **optimal combination of asset weights** in order to **maximize** the fitness function.  

### **Problem Setup**  

The optimization problem is defined as follows:  

- A portfolio consisting of **three assets**, each with its **historical return time series** (1397 daily closing stock prices).  
- The **covariance matrix** of the historical returns.  
- A **threshold return** constraint: $\pi$.  
- A **fitness function**: $\text{prtf1}(x)$.  

The **fitness function** is the objective function that the GA seeks to **minimize**. It evaluates the quality of a solution by incorporating multiple factors:  

1. **Portfolio variance**, which measures the portfolio’s risk.  
2. **Penalty for violating the return target constraint**, ensuring that the expected return meets or exceeds $\pi$.  
3. **Penalty for violating the budget constraint**, enforcing that the sum of the asset weights is as close as possible to 1.  

Since we are working in a **simplified environment**, we exclude the use of **leverage** (such as borrowing or derivatives to increase exposure beyond invested capital). If the sum of weights deviates from 1, a **penalty** is added to the fitness function.  

---

## **Grid Search for Optimal Parameters**  

A **grid search** approach was employed to identify the best set of parameters for the Genetic Algorithm. The following hyperparameters were explored:  

- **Number of runs:** `[50, 100]`  
- **Population size** (`opts.PopulationSize`): `[5, 10, 50]`  
- **Generations** (`opts.Generations`): `[25, 100]`  
- **Crossover fraction** (`opts.CrossoverFraction`): `[0.1, 0.8]`  
- **Mutation fraction** (`opts.MutationFraction`): `[0.01, 0.05]`  

### **Optimal Parameter Considerations**  

The parameter exploration yielded interesting insights:  

- A **higher number of runs (100)** was generally preferred over a lower number (50).  
- A **larger population size (50)** consistently performed better than smaller values, suggesting a balance between exploration and exploitation in the search space.  
- **100 generations** were generally more effective than 25, allowing for a more refined solution.  
- The **crossover fraction** tended to converge around **0.8**, indicating a strong preference for crossover, which enhances population diversity.  
- The **mutation fraction** had a **less pronounced** impact, suggesting that mutation played a relatively minor role in the optimization process.  

Additionally, execution time remained relatively **consistent across different parameter values**, suggesting that computational overhead from parameter tuning or constraint enforcement did not significantly affect runtime. While parameter tuning is crucial for achieving optimal solutions, it does not necessarily impose substantial computational costs.  

---

## **Algorithm Execution**  

The algorithm **iterates through multiple generations** to identify an optimal solution. Once a solution is found, it is compared to the **theoretical solution** derived from the **mean-variance frontier**, which is calculated analytically.  

It is important to note that the **iterative process does not guarantee convergence** to the optimal solution. However, in cases where the problem is **large and complex** (e.g., multiple assets, nonlinear constraints, transaction costs, weight limits), Genetic Algorithms become a **valuable alternative** to analytical approaches, which may be impractical due to computational constraints.





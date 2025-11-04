import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

# Определяем квадратичную функцию и её градиент
def f(x, y):
    return 2.5*x**2 + 1*x*y + 2*y**2 + 12*x + 0.5*y

def grad_f(x, y):
    df_dx = 5*x + 1*y + 12
    df_dy = 1*x + 4*y + 0.5
    return np.array([df_dx, df_dy])

# Метод градиентного спуска
def gradient_descent(x0, epsilon=1e-3, alpha=0.1, max_iter=1000):
    x = np.array(x0, dtype=float)
    trajectory = [x.copy()]
    num_func_evals = 1
    iter_count = 0

    while iter_count < max_iter:
        grad = grad_f(x[0], x[1])
        x_new = x - alpha * grad
        trajectory.append(x_new.copy())
        num_func_evals += 1
        iter_count += 1
        if np.linalg.norm(x_new - x) < epsilon:
            break
        x = x_new

    result = {
        "x_min": x,
        "f_min": f(x[0], x[1]),
        "iterations": iter_count,
        "func_evals": num_func_evals,
        "trajectory": np.array(trajectory)
    }
    return result

# Параметры исследования
epsilons = [1e-1, 1e-3, 1e-5]
x0_list = [[0, 0], [-5, 5], [5, -5]]
alpha = 0.1

# Таблица результатов
results = []

for x0 in x0_list:
    for eps in epsilons:
        res = gradient_descent(x0, epsilon=eps, alpha=alpha)
        results.append({
            "x0": x0,
            "epsilon": eps,
            "iterations": res["iterations"],
            "func_evals": res["func_evals"],
            "x_min": res["x_min"],
            "f_min": res["f_min"]
        })

df = pd.DataFrame(results)
print(df)

# Визуализация траекторий для первого начального приближения
x_range = np.linspace(-10, 10, 400)
y_range = np.linspace(-10, 10, 400)
X, Y = np.meshgrid(x_range, y_range)
Z = f(X, Y)

plt.figure(figsize=(8, 6))
plt.contour(X, Y, Z, levels=30, cmap='viridis')
for x0 in x0_list:
    res = gradient_descent(x0, epsilon=1e-3, alpha=alpha)
    traj = res["trajectory"]
    plt.plot(traj[:, 0], traj[:, 1], marker='o', label=f"x0={x0}")

plt.title("Траектория градиентного спуска на фоне линий уровня функции")
plt.xlabel("x")
plt.ylabel("y")
plt.legend()
plt.show()

# Выводы о сходимости
for eps in epsilons:
    subset = df[df['epsilon'] == eps]
    print(f"\nТочность {eps}:")
    print(subset[["x0", "iterations", "func_evals", "x_min", "f_min"]])

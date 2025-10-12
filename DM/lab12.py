import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import linprog

c = [-30, -40]

A = [
    [12, 4],
    [4, 4],
    [3, 12],
    [-1, 1]
]


b = [300, 120, 252, 0]

b_base = b.copy()
c_base = c.copy()

bounds = [(0, None), (0, None)]

def describe():
    print("=== Переменные модели ===")
    print("x_A: количество деталей типа A, выпускаемых в день (x_A >= 0)")
    print("x_B: количество деталей типа B, выпускаемых в день (x_B >= 0)")
    print("Особое условие: x_B >= x_A (деталей B нужно выпускать не меньше, чем A)\n")
    
    print("=== Параметры модели ===")
    print("Сырьё I: a_I_A = 12 кг на деталь A, a_I_B = 4 кг на деталь B, доступно S_I = 300 кг")
    print("Сырьё II: a_II_A = 4 кг на деталь A, a_II_B = 4 кг на деталь B, доступно S_II = 120 кг")
    print("Сырьё III: a_III_A = 3 кг на деталь A, a_III_B = 12 кг на деталь B, доступно S_III = 252 кг")
    print("Прибыль: p_A = 30 ден. ед. за деталь A, p_B = 40 ден. ед. за деталь B\n")
    
    print("=== Целевая функция ===")
    print("Максимизировать суммарную прибыль:")
    print("Z = 30*x_A + 40*x_B -> max\n")
    
    print("=== Ограничения ===")
    print("1) По сырью:")
    print("   12*x_A + 4*x_B <= 300 (сырьё I)")
    print("   4*x_A + 4*x_B <= 120 (сырьё II)")
    print("   3*x_A + 12*x_B <= 252 (сырьё III)")
    print("2) Минимальное количество деталей B относительно A: x_B >= x_A")
    print("3) Неотрицательность переменных: x_A >= 0, x_B >= 0\n")
    
    print("=== Дополнительно ===")
    print("Эта модель позволяет определить оптимальное количество деталей A и B для максимальной прибыли с учётом ограничений на сырьё.")

describe()
res = linprog(c, A_ub=A, b_ub=b, bounds=bounds, method='highs')
x_opt, y_opt = res.x
max_profit = -res.fun

print(f"Оптимальное количество деталей A: {x_opt:.2f}")
print(f"Оптимальное количество деталей B: {y_opt:.2f}")
print(f"Максимальная прибыль: {max_profit:.2f}")

x = np.linspace(0, 30, 400)  

y1 = (300 - 12*x)/4
y2 = (120 - 4*x)/4
y3 = (252 - 3*x)/12       
y4 = x                   

def sensitivity_resource(resource_index, delta_values):
    print(f"\n=== Анализ чувствительности для сырья {resource_index+1} ===")
    for delta in delta_values:
        b_new = b.copy()
        b_new[resource_index] += delta
        res = linprog(c, A_ub=A, b_ub=b_new, bounds=bounds, method='highs')
        print(f"Изменение сырья: {delta:+} кг -> x_A={res.x[0]:.2f}, x_B={res.x[1]:.2f}, Z={-res.fun:.2f}")

sensitivity_resource(0, [-20, 0, 20])

plt.figure(figsize=(10,7))

plt.plot(x, y1, label='12x_A + 4x_B <= 300')
plt.plot(x, y2, label='4x_A + 4x_B <= 120')
plt.plot(x, y3, label='3x_A + 12x_B <= 252')
plt.plot(x, y4, label='x_B >= x_A')

plt.fill_between(x, np.maximum.reduce([y4, np.zeros_like(x)]), np.minimum.reduce([y1, y2, y3]), color='gray', alpha=0.3)

plt.plot(x_opt, y_opt, 'ro', markersize=8, label='Оптимум')
plt.text(x_opt+0.5, y_opt+0.5, f"Z_max={max_profit:.2f}", color='red')

plt.xlim(0, 30)
plt.ylim(0, 30)
plt.xlabel('Количество деталей A (x_A)')
plt.ylabel('Количество деталей B (x_B)')
plt.title('Графическое решение задачи линейного программирования')
plt.legend()
plt.grid(True)
plt.show()

resource_index = 0  
delta_values = np.arange(-50, 51, 10)  

xA_list, xB_list, Z_list = [], [], []

for delta in delta_values:
    b_new = b_base.copy()
    b_new[resource_index] += delta
    res = linprog(c_base, A_ub=A, b_ub=b_new, bounds=bounds, method='highs')
    xA_list.append(res.x[0])
    xB_list.append(res.x[1])
    Z_list.append(-res.fun)

# ---------------------------
# Построение графика
# ---------------------------
plt.figure(figsize=(10,6))
plt.plot(delta_values, xA_list, 'o-', label='x_A (детали A)')
# plt.plot(delta_values, xB_list, 's-', label='x_B (детали B)')
# plt.plot(delta_values, Z_list, '^-', label='Прибыль Z')
plt.xlabel('Изменение доступного сырья I (Δ кг)')
plt.ylabel('Оптимальные значения')
plt.title('Анализ чувствительности к сырью I')
plt.grid(True)
plt.legend()
plt.show()


# ---------------------------
# Анализ чувствительности по прибыли деталей
# ---------------------------
delta_profit = np.arange(-10, 11, 5)  # Изменение прибыли от -10 до +10

xA_list, xB_list, Z_list = [], [], []

for delta in delta_profit:
    c_new = [-(30 + delta), -40]  # меняем прибыль для деталей A
    res = linprog(c_new, A_ub=A, b_ub=b_base, bounds=bounds, method='highs')
    xA_list.append(res.x[0])
    xB_list.append(res.x[1])
    Z_list.append(-res.fun)

plt.figure(figsize=(10,6))
plt.plot(delta_profit, xA_list, 'o-', label='x_A (детали A)')
# plt.plot(delta_profit, xB_list, 's-', label='x_B (детали B)')
# plt.plot(delta_profit, Z_list, '^-', label='Прибыль Z')
plt.xlabel('Изменение прибыли детали A (Δ ден. ед.)')
plt.ylabel('Оптимальные значения')
plt.title('Анализ чувствительности к прибыли деталей A')
plt.grid(True)
plt.legend()
plt.show()

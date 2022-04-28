
import matplotlib.pyplot as plt
import random
import math

TARGET = 100.0
    

def get_rate(price):
    return 1 - math.exp(-(price/TARGET)**4)

def main():
    current_price = random.randint(TARGET/2, TARGET*2)
    price_evolution = [i for i in range(int(current_price), int(TARGET)*2, 15)]
    rate_evolution = [get_rate(i) for i in price_evolution]

    plt.plot(price_evolution, rate_evolution)
    plt.ylabel('Rates')
    plt.xlabel('Price')
    plt.show()

if __name__ == "__main__":
    main()
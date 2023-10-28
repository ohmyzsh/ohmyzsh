import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from scipy.stats import linregress

def draw_plot():
    # Read data from file
    df = pd.read_csv('epa-sea-level.csv')
    
    # Create scatter plot
    fig, ax = plt.subplots()
    ax.scatter(x="Year", y="CSIRO Adjusted Sea Level", data=df, label='Data')

    # Create first line of best fit
    slope, intercept, r_value, p_value, std_err = linregress(df["Year"], df["CSIRO Adjusted Sea Level"])
    years = np.arange(1880, 2050)
    ax.plot(years, intercept + slope * years, 'r', label='First line of best fit')

    # Create second line of best fit
    df2 = df.loc[df["Year"] >= 2000]
    slope2, intercept2, r_value2, p_value2, std_err2 = linregress(df2["Year"], df2["CSIRO Adjusted Sea Level"])
    years2 = np.arange(2000, 2050)
    ax.plot(years2, intercept2 + slope2 * years2, 'b', label='Second line of best fit')

    # Add labels and title
    ax.set(xlabel="Year", ylabel="Sea Level (inches)", title="Rise in Sea Level")

    # Add legend
    ax.legend()

    # Save plot and return data for testing (DO NOT MODIFY)
    plt.savefig('sea_level_plot.png')
    return plt.gca()

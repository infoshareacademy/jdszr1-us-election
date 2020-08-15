import pandas as pd
import os
import numpy as np


def choose_state():
    with open("dane/states.csv", "r") as plik:
        states = [linia.rstrip() for linia in plik]
    print("\nLista state codes:")
    print(states)
    state_code = input("\nPodaj kod stanu, w którym chcesz się ubezpieczyć:")
    if state_code in states:
        return state_code
    else:
        print("\nNiepoprawny state code. Wybierz z listy.")
        state_code = input("Podaj kod stanu, w którym chcesz się ubezpieczyć:")
        return state_code


def choose_age():
    try:
        age_input = int(input("\nPodaj swój wiek:"))
    except ValueError:
        print("\nTo nie jest liczba")
        age_input = int(input("Podaj swój wiek:"))
    
    if age_input <= 20:
        age = '0-20'
    elif age_input >= 65:
        age = '65 and over'
    else:
        age = age_input
    return str(age)


def choose_option():
    opt_dict = {
        1:"IndividualRate",
        2:"Couple",
        3:"PrimarySubscriberAndOneDependent",
        4:"PrimarySubscriberAndTwoDependents",
        5:"PrimarySubscriberAndThreeOrMoreDependents",
        6:"CoupleAndOneDependent",
        7:"CoupleAndTwoDependents",
        8:"CoupleAndThreeOrMoreDependents"
        }
    print("\nPoniższa lista prezentuje dostępne opcje ubezpieczenia rodzinnego:")
    print("\n 2 - Couple\n 3 - Primary Subscriber and One Dependent\n 4 - Primary Subscriber and Two Dependents\n 5 - Primary Subscriber and Three or More Dependents\n 6 - Couple And One Dependent\n 7 - Couple And Two Dependents\n 8 - Couple And Three or More Dependents\n")
    option = int(input("Z powyższej listy wybierz numer opcji ubezpieczenia:"))
    if option in range(2,9):
        return option
    else:
        print("\nNie ma takiej opcji. Wybierz numer z listy")
        option = int(input("Z powyższej listy wybierz numer opcji ubezpieczenia:"))
        return option

def get_data():
    family = input("Czy chcesz się ubezpieczyć z rodziną? y/n:")
    if family == 'y':
        age = 'Family Option'
        option = choose_option()
    else:
        age = choose_age()
        option = 1
    return (age, option)

def show_result(state_code, age, option, network_df, pa_df, rate_df):

    opt_dict = {
        1:"IndividualRate",
        2:"Couple",
        3:"PrimarySubscriberAndOneDependent",
        4:"PrimarySubscriberAndTwoDependents",
        5:"PrimarySubscriberAndThreeOrMoreDependents",
        6:"CoupleAndOneDependent",
        7:"CoupleAndTwoDependents",
        8:"CoupleAndThreeOrMoreDependents"
        }

    network_df = network_df[['IssuerId', 'NetworkName']]
    pa_df = pa_df[['StandardComponentId', 'PlanMarketingName']]
    pa_df = pa_df.rename(columns = {'StandardComponentId':'PlanId'})
    join1 = pd.merge(rate_df, network_df, on="IssuerId", how="inner")
    join_final = pd.merge(join1, pa_df, on="PlanId", how="inner")
    new_df = join_final[[opt_dict[option], 'PlanId', 'PlanMarketingName', 'NetworkName']][(join_final["StateCode"] == state_code) & (join_final["Age"] == age) & (join_final[opt_dict[option]] != 0)]
    new_df = new_df.sort_values(opt_dict[option])
    q1 = np.percentile(new_df[opt_dict[option]], 25)
    q2 = np.percentile(new_df[opt_dict[option]], 50)
    q3 = np.percentile(new_df[opt_dict[option]], 75)
    min(new_df[opt_dict[option]])
    q0_df = new_df[new_df[opt_dict[option]] == min(new_df[opt_dict[option]])].head(n=1)
    q1_df = new_df[new_df[opt_dict[option]] == q1].head(n=1)
    q2_df = new_df[new_df[opt_dict[option]] == q2].head(n=1)
    q3_df = new_df[new_df[opt_dict[option]] == q3].head(n=1)
    final = pd.concat([q0_df,q1_df,q2_df,q3_df])
    return(final.reset_index(drop = True))
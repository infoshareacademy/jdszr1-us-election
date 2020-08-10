import pandas as pd
import os
import numpy as np


def pobierz_state():
    with open("dane/states.csv", "r") as plik:
        states = [linia.rstrip() for linia in plik]
    print("Lista state codes:")
    print(states)
    state_code = input("State code:")
    if state_code in states:
        return state_code
    else:
        print("Niepoprawny state code. Wybierz z listy.")
        state_code = input("State code:")
        return state_code


def pobierz_wiek():
    try:
        age_input = int(input("Wiek:"))
    except ValueError:
        print("To nie jest liczba")
        age_input = int(input("Wiek:"))
    
    if age_input <= 20:
        age = '0-20'
    elif age_input >= 65:
        age = '65 and over'
    else:
        age = age_input
    return str(age)


def pobierz_opcje():
    opcje_dict = {
        1:"IndividualRate",
        2:"Couple",
        3:"PrimarySubscriberAndOneDependent",
        4:"PrimarySubscriberAndTwoDependents",
        5:"PrimarySubscriberAndThreeOrMoreDependents",
        6:"CoupleAndOneDependent",
        7:"CoupleAndTwoDependents",
        8:"CoupleAndThreeOrMoreDependents"
        }
    print(" 2 - Couple\n 3 - Primary Subscriber and One Dependent\n 4 - Primary Subscriber and Two Dependents\n 5 - Primary Subscriber and Three or More Dependents\n 6 - Couple And One Dependent\n 7 - Couple And Two Dependents\n 8 - Couple And Three or More Dependents\n")
    opcja = int(input("Podaj numer opcji ubezpieczenia:"))
    if opcja in range(2,9):
        return opcja
    else:
        print("Nie ma takiej opcji. Wybierz numer z listy")
        opcja = int(input("Podaj numer opcji ubezpieczenia:"))
        return opcja

def pobierz_dane():
    family = input("Czy chcesz się ubezpieczyć z rodziną? y/n:")
    if family == 'y':
        age = 'Family Option'
        opcja = pobierz_opcje()
    else:
        age = pobierz_wiek()
        opcja = 1
    return (age, opcja)

def pokaz_wynik(state_code, age, opcja, network_df, pa_df, rate_df):

    opcje_dict = {
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
    new_df = join_final[[opcje_dict[opcja], 'PlanId', 'PlanMarketingName', 'NetworkName']][(join_final["StateCode"] == state_code) & (join_final["Age"] == age) & (join_final[opcje_dict[opcja]] != 0)]
    new_df = new_df.sort_values(opcje_dict[opcja])
    q1 = np.percentile(new_df[opcje_dict[opcja]], 25)
    q2 = np.percentile(new_df[opcje_dict[opcja]], 50)
    q3 = np.percentile(new_df[opcje_dict[opcja]], 75)
    min(new_df[opcje_dict[opcja]])
    q0_df = new_df[new_df[opcje_dict[opcja]] == min(new_df[opcje_dict[opcja]])].head(n=1)
    q1_df = new_df[new_df[opcje_dict[opcja]] == q1].head(n=1)
    q2_df = new_df[new_df[opcje_dict[opcja]] == q2].head(n=1)
    q3_df = new_df[new_df[opcje_dict[opcja]] == q3].head(n=1)
    final = pd.concat([q0_df,q1_df,q2_df,q3_df])
    return(final.reset_index(drop = True))
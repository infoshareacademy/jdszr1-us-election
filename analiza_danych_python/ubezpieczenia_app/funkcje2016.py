import pandas as pd
import os
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns


def choose_state():
    with open("dane/states.csv", "r") as plik:
        states = [linia.rstrip() for linia in plik]
    print("\nLista state codes:")
    print(states)
    while True:
        state_code = input("\nPodaj kod stanu, w którym chcesz się ubezpieczyć:")
        if state_code in states:
            return state_code
            break
        else:
            print("\nNiepoprawny state code. Wybierz z listy.")
            


def choose_age():
    while True:
        age_input = input("\nPodaj swój wiek:")
        if age_input.isnumeric() and (int(age_input) < 120) and (int(age_input) >= 0) :
            if int(age_input) <= 20:
                age = '0-20'                               
            elif int(age_input) >= 65:
                age = '65 and over'                
            else:
                age = age_input
            return age
            break
        else:
            print("Nieprawidłowa wartość. Podaj liczbę od 0 do 120.")
        


def choose_option():
    print("\nPoniższa lista prezentuje dostępne opcje ubezpieczenia rodzinnego:")
    print("\n 2 - Couple\n 3 - Primary Subscriber and One Dependent\n 4 - Primary Subscriber and Two Dependents\n 5 - Primary Subscriber and Three or More Dependents\n 6 - Couple And One Dependent\n 7 - Couple And Two Dependents\n 8 - Couple And Three or More Dependents\n")
    while True:
        option = input("Z powyższej listy wybierz numer opcji ubezpieczenia:")
        if option.isnumeric():
            if int(option) in range(2,9):
                return int(option)
                break
            else:
                print("Nie ma takiej opcji. Wybierz numer z listy.")
        else:
            print("\nNie ma takiej opcji. Wybierz numer z listy.")
            

def get_data():
    while True:
        family = input("Czy chcesz się ubezpieczyć z rodziną? y/n:")
        if family == 'y' or family == 'n':
            if family == 'y':
                age = 'Family Option'
                option = choose_option()
            elif family == 'n':
                age = choose_age()
                option = 1
            return (age, option)
            break
        else:
            print("To nie jest poprawna odpowiedź. Wpisz \"y\" dla yes lub \"n\" dla no.")



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



def show_final(state_code, age, option, network_df, pa_df, rate2016_df):
    
    try:
        plan_output = show_result(state_code, age, option, network_df, pa_df, rate2016_df)
    except IndexError:
        print("\nNiestety nie dysponujemy planem ubezpieczeniowym dla podanych kryteriów")
        return pd.DataFrame()
    return plan_output
    


def print_options(plan_output, age, option):
    #Rysunje wykres wybranych obcji

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

    if age == "Family Option":
        Rate=plan_output[opt_dict[option]]
    else:
        Rate=plan_output["IndividualRate"]

    
    PlanName = plan_output["PlanMarketingName"] + " - by Issuer - " + plan_output["NetworkName"]

    sns.barplot(x=PlanName, y=Rate)
    plt.title("Top - Twój najlepszy wybor")
    plt.xlabel("Nazwa planu ubezpieczeniowego")
    plt.ylabel("Cena miesieczna $")
    locs, labels = plt.xticks()
    plt.setp(labels, rotation=90)
    



def choose_benefit(plan_output, df_bcs):
    print("\n\nW poniższych tabelach zaprezentowane zostały benefity, dla każdego z czterech powyższych planów")
    input_StandardComponentId = np.array(plan_output['PlanId'])
    for pl_id in input_StandardComponentId:
        g = df_bcs[df_bcs.StandardComponentId.eq(pl_id) & df_bcs.BenefitName.str.contains('Dental', na=False) & df_bcs.IsCovered.eq('Covered')]
        g = g.rename(columns = {'StandardComponentId':'PlanIdBase'})
        g = g.rename(columns = {'CoinsInnTier1':'ExtraCharge'})
        df_g = g[['PlanIdBase', 'BenefitName', 'ExtraCharge', 'LimitQty', 'LimitUnit']].head(5)
        df_g = df_g.fillna("N/A")
        display(df_g.reset_index(drop= True))



def best_healthcare(network_df, pa_df, rate2016_df, bcs_df):
    print("Aplikacja służąca do wyboru ubezpieczenia zdrowotnego\n")
    print("W pierwszym kroku zadamy Ci kilka pytań dotyczących Twoich preferencji odnośnie ubezpieczenia:")
    
    
    state_code = choose_state()
    age,option = get_data()

    plan_output = show_final(state_code, age, option, network_df, pa_df, rate2016_df)
    if plan_output.empty:
        return
    else:
        print("\nPoniżej znajdują się wybrane dla Ciebie plany ubezpieczeniowe:")
        display(plan_output)
        print_options(plan_output, age, option)
        choose_benefit(plan_output, bcs_df)

    
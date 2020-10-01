import ipywidgets as widgets
from IPython.display import display
import numpy as np
import pandas as pd

def widgets():
    import ipywidgets as widgets
    from IPython.display import display
    
    print('Prosimy o wypełnienie poniższego kwestionariusza i zaznaczenie odpowiednich opcji\n')

    sex_w = widgets.RadioButtons(options=['Kobieta', 'Mężczyzna'],
        description='Płeć:',
        disabled=False)
    print("Zaznacz swoją płeć:")
    display(sex_w)
    
    age_w = widgets.IntSlider(min=1, max=120)
    print("Podaj swój wiek:")
    display(age_w)
    
    height_w = widgets.FloatSlider(min=1, max=2.5, step=0.01, description='Wzrost')
    weight_w = widgets.IntSlider(min=10, max=200, description='Waga')
    print("Podaj swój wzrost (w metrach) oraz wagę (w kilogramach):")
    display(height_w, weight_w)
    
    smoker_w = widgets.Dropdown(options=["Nie", "Tak"], description='Czy palisz?:')
    display(smoker_w)
    
    children_w = widgets.Dropdown(options=[0, 1, 2, 3, 4, 5, 6], description='Ilość dzieci:')
    print('Podaj liczbę swoich dzieci:')
    display(children_w)
    
    region_w = widgets.RadioButtons(options=['southeast', 'southwest', 'norteast', 'nortwest'],
        description='Region:',
        disabled=False)
    print('Zaznacz swój region:')
    display(region_w)
    
    return sex_w, age_w, height_w, weight_w, smoker_w, children_w, region_w

def values(sex_w, age_w, height_w, weight_w, smoker_w, children_w, region_w):
    sex = sex_w.value
    age = age_w.value
    height = height_w.value
    weight = weight_w.value
    bmi = weight/(height**2)
    smoker = smoker_w.value
    children = children_w.value
    region = region_w.value
    return sex, age, bmi, smoker, children, region

def create_df(sex, age, bmi, smoker, children, region):
    columns = ['age', 'bmi', 'children', 'charges', 'sex_male', 'smoker_yes',
       'region_northeast', 'region_northwest', 'region_southeast',
       'region_southwest']
    index = ['0']
    new_df = pd.DataFrame(index=index, columns=columns)
    new_df = new_df.fillna(0)
    
    new_df['age'] = age
    new_df['bmi'] = bmi
    new_df['children'] = children

    if sex == 'Kobieta':
        new_df['sex_male'] = 0
    else:
        new_df['sex_male'] = 1

    if smoker == 'No':
        new_df['smoker_yes'] = 0
    else:
        new_df['smoker_yes'] = 1

    new_df[region] = 1
    
    return new_df

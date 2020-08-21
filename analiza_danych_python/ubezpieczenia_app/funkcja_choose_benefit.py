import pandas as pd
import numpy as np
import os
import funkcje as f

def choose_benefit(plan_output, df_bcs):
    input_StandardComponentId = np.array(plan_output['PlanId'])
    g = df_bcs[df_bcs.StandardComponentId.isin(input_StandardComponentId) & df_bcs.BenefitName.str.contains('Dental', na=False) & df_bcs.IsCovered.eq('Covered')]
    g = g.rename(columns = {'StandardComponentId':'PlanIdBase'})
    g = g.rename(columns = {'CoinsInnTier1':'ExtraCharge'})
    df_g = g[['PlanIdBase', 'BenefitName', 'ExtraCharge', 'LimitQty', 'LimitUnit']]
    df_g = df_g.fillna("N/A")
    return(df_g.reset_index(drop= True))

        

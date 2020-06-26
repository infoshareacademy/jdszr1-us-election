# jdszr1-us-election

## Temat: US Election - czy demografia determinuje na kogo ludzie głosują? Przegląd ogólnych statystyk demograficznych, ciekawych przypadków i anomalii


#### Baza danych:
county_facts - tabela zawierający statystyki dla regionów USA 

county_facts_dictionary - tabela zawierająca objaśnienia nazw kolumn z tabeli county_facts

primary_results - tabela zawierająca wyniki głosowania dla poszczególnych regionów


#### Na analizę składa się szereg plików dokonujących przekształceń dostępnych danych oraz obliczających (i prezentujących) ciekawe statystyki. Poniżej znajduje się opis zawartości repozytorium.

1. plik **create_table_counties.sql** - służy do utworzenia nowej tabeli "counties", bazującej na danych z tabel county_facts oraz county_facts_dictionary.

2. pliki **create_table_candidates.sql** oraz **candidates.csv** - służą do stworzenia nowej tabeli "candidates", zawierającej dane o kandydatach (.sql tworzy tabelę, następnie do tej tabeli należy zaimportować dane z pliku .csv).

3. plik **analiza_czystosci_danych.sql** - zawiera opisane i wykonane testy danych do projektu, opisane i wykonane są również zmiany w tabelach z danymi.

4. folder **black_votes_analysis**: analiza wyników jedynego kandydata afroamerykanina - plik **ben_carson.sql**, tworzący nową tabelę pomocniczą "ben_carson" oraz wykonujący na niej obliczenia; plik **ben_carson_high.xlsx** - zawierający m.in. wykresy obrazujące zależności między wynikiem głosowania a statystykami demograficznymi, analizy w pliku xlsx odnoszą się do okręgów,w których wynik kandydata był wyższy niż 75 percentyl.

5. folder **women_votes_analysis**: analiza wyników kobiet (Hilary Clinton oraz Carly Fiorina) - plik **women.sql**, tworzący nową tabelę pomocniczą "women" oraz wykonujący na niej obliczenia; plik **women.xlsx** zawierający m.in. wykresy obrazujące zależności między wynikami głosowania a statystykami demograficznymi.

6. **Bernie_Sanders.sql** - plik z analizą wyników głosowania dla kandydata Bernie_Sanders oraz **Bernie_Sanders.xls** - prezentacja wyników analizy / wniosków.

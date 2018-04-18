# NoSQL
#### Aleksandra Onych - projekt na zaliczenie laboratorium 

[Baza danych - Medallion Vehicles - Authorized](https://catalog.data.gov/dataset/medallion-vehicles-authorized-44673)

## Projekt na zaliczenie laboratorium
Aplikacja korzysta z tych samych danych, które użyte były w projekcie *Moje dane*. Jest napisana w języku ***Java*** z wykorzystaniem: *Maven*, *JFreeChart*, *MongoDB Driver*.
W folderze *bin* znajdują się skrypty do uruchomienia aplikacji.

### Skrypty
#### createIndexes.sh
  Skryp odpowiedzialny za stworzenie indeksów w kolekcji. Należy go wykonać tylko raz.
  

#### vehicleTypesPieChartToImage.sh
  Skrypt odpowiada za wygenerowanie wykresu kołowego przedstawiającego ilość pojazdów danego typu. Wykres ten zapisywany jest jako obrazek w formacie *.jpeg*.
  [PieChart.jpeg](https://github.com/nosql/app-cli-aonych/blob/master/PieChart.jpeg)
  
  
#### countDaysToExpirationDate.sh
Skrypt oblicza ilość dni jaka pozostała do wygaśnięcia danej licencji. Wynik wyświetlany jest zarówno w terminalu jak i w oknie informacyjnym. Jeśli podamy błędny numer licencji lub licencja już wygasła - otrzymamy odpowiedni komunikat.

Przykład wywołania skryptu dla licencji *1H45*
```
./countDaysToExpirationDate.sh 1H45
```

Powodzenie: [liczbaDniDoWygasniecia.png](https://github.com/nosql/app-cli-aonych/blob/master/grafiki/liczbaDniDoWygasniecia.PNG)

Licencja wygasła: [licencjaWygasla.png](https://github.com/nosql/app-cli-aonych/blob/master/grafiki/licencjaWygasla.PNG)

Błędny numer licencji: [niepoprawnyNumerLicencji.png](https://github.com/nosql/app-cli-aonych/blob/master/grafiki/niepoprawnyNumerLicencji.PNG)


#### info.sh
  Skrypt odpowiada za wygenerowanie pliku tekstowego z informacjami na temat kolekcji. W pliku tym znajduje się nazwa bazy, kolekcji, wielkość kolekcji oraz nazwy wszystkich kolumn w kolekcji.
  [collectionInfo.txt](https://github.com/nosql/app-cli-aonych/blob/master/collectionInfo.txt)
  ```
  Nazwa bazy danych: test
Nazwa kolekcji: vehicles
Wielkosc kolekcji: 5805825
Nazwy kolumn: 
		 Expiration Date
		 License Number
		 Agent Address
		 Vehicle Type
		 DMV License Plate Number
		 Agent Number
		 Agent Name
		 Name
		 Agent Telephone Number
		 Vehicle VIN Number
		 Model Year
		 Last Date Updated
		 Agent Website Address
		 Last Time Updated
		 Medallion Type
		 _id
		 Current Status
```

## Moje dane
### Skrypty
Wszystkie skrypty znajdują się w folderze bin. 
#### importStandalone.sh 
  Skryp odpowiada za wykonanie importu danych w standalone przy domyślnych ustawieniach *write concern*. Importy dla obu zbiorów danych ('mazowieckie' oraz 'vehicles') są wykonane w pętli 5-krotnie. Czasy importów zapisywane są w plikach **mazowieckie.csv** oraz **vehicles.csv**.
  
#### importReplicaSet.sh
  Jest to skrypt odpowiedziany za uruchomienie replica set oraz import danych. Importy wykonywane są w pętli 5-krotnie, przy 5 ustawieniach *write concern*:
  * domyślne (w: 1)
  * w: 1, j: false
  * w: 1, j: true
  * w: 2, j: false
  * w: 2, j: true
Czasy importów zapisywane są w plikach **mazowieckie2.csv** oraz **vehicles2.csv**.

#### importResult.sh
  Skrypt pobiera wyniki importów z plików *csv* i zapisuje je w nowej kolekcji w bazie.
  
#### generateTable.sh
  Jest to skrypt, który generuję końcową tabelkę z wynikami przeprowadzonych testów. Zastosowana jest w nim agregacja na danych z kolekcji *data*, w której znajdują się wyniki importów.


## Średnie czasy wykonania importu danych (5 powtórzeń importu)

| Collection name | Columns |    Type     |         Write Concern      |               Time averages          |
| --------------- |:-------:|:-----------:|:--------------------------:|:------------------------------------:|
|   mazowieckie   | 1093203 | standalone  |           default          | real: 56.40s user: 5.38s sys: 0.87s  |
|   mazowieckie   | 1093203 | replica_set |           default          | real: 173.55s user: 5.11s sys: 0.90s |
|   mazowieckie   | 1093203 | replica_set |         {w:1,j:false}      | real: 161.26s user: 5.32s sys: 0.87s |
|   mazowieckie   | 1093203 | replica_set |         {w:1,j:true}       | real: 168.02s user: 5.20s sys: 0.77s |
|   mazowieckie   | 1093203 | replica_set |         {w:2,j:false}      | real: 169.74s user: 5.09s sys: 0.85s |
|   mazowieckie   | 1093203 | replica_set |         {w:2,j:true}       | real: 169.77s user: 5.09s sys: 0.86s |
|                 |         |             |                            |                                      |
|    vehicles     | 5805825 | standalone  |           default          | real: 208.22s user: 7.79s sys: 1.11s |
|    vehicles     | 5805825 | replica_set |           default          | real: 772.98s user: 7.90s sys: 1.12s |
|    vehicles     | 5805825 | replica_set |         {w:1,j:false}      | real: 771.79s user: 8.18s sys: 1.22s |
|    vehicles     | 5805825 | replica_set |         {w:1,j:true}       | real: 819.94s user: 8.30s sys: 1.20s |
|    vehicles     | 5805825 | replica_set |         {w:2,j:false}      | real: 797.22s user: 8.18s sys: 1.16s |
|    vehicles     | 5805825 | replica_set |         {w:2,j:true}       | real: 803.50s user: 7.97s sys: 1.09s |



### ReplicaSet
Nie udało mi się wykonać pełnego pomiaru czasów importu danych w replica set. Czasy te okazały się bardzo duże w porównaniu do standalone (pierwszy import trwał ponad 19minut). Niżej zamieszczone są wyniki importu danych dla województwa mazowieckiego, które udało mi się odnotować:

### UPDATE 
Po nieudanych pomiarach na maszynie wirtualnej (problem podany powyżej), postanowiłam spróbować importu na systemie zainstalowanym na komputerze (Windows + skrypty uruchamiane przez *git bash*). Tym razem czas importu był o wiele krótszy. 

#### Wyniki pojedynczych importów w Replica Set
##### Mazowieckie
(--writeConcern "{w: 1}")
Import...
2018-03-19T00:25:57.262-0400    imported 1093203 documents
 
real    15m3.770s
user    1m42.480s
sys 0m27.148s

(--writeConcern "{w: 1}")
2018-03-19T00:35:49.200-0400    imported 1093203 documents
 
real    9m50.537s
user    1m14.368s
sys 0m15.444s
747
88

(--writeConcern "{w: 1, j: false}")
2018-03-19T00:46:12.226-0400    imported 1093203 documents
 
real    10m21.262s
user    1m15.396s
sys 0m16.700s

#### UPDATE (Windows + git bash)
##### Mazowieckie
```
colNumber: 1093203 type: "replica_set" write_concern: "default" real: 177.527 user: 5.233 sys: 0.92
colNumber: 1093203 type: "replica_set" write_concern: "default" real: 175.587 user: 4.796 sys: 1.045
colNumber: 1093203 type: "replica_set" write_concern: "default" real: 174.52 user: 5.014 sys: 0.903
colNumber: 1093203 type: "replica_set" write_concern: "default" real: 169.488 user: 5.186 sys: 0.701
colNumber: 1093203 type: "replica_set" write_concern: "default" real: 170.671 user: 5.342 sys: 0.952
colNumber: 1093203 type: "replica_set" write_concern: "{w:1,j:false}" real: 173.797 user: 5.875 sys: 1.014
colNumber: 1093203 type: "replica_set" write_concern: "{w:1,j:false}" real: 157.633 user: 5.343 sys: 0.81
colNumber: 1093203 type: "replica_set" write_concern: "{w:1,j:false}" real: 156.115 user: 5.28 sys: 0.779
colNumber: 1093203 type: "replica_set" write_concern: "{w:1,j:false}" real: 162.181 user: 4.983 sys: 0.811
colNumber: 1093203 type: "replica_set" write_concern: "{w:1,j:false}" real: 156.579 user: 5.125 sys: 0.983
colNumber: 1093203 type: "replica_set" write_concern: "{w:1,j:true}" real: 163.466 user: 5.187 sys: 0.812
colNumber: 1093203 type: "replica_set" write_concern: "{w:1,j:true}" real: 167.057 user: 5.186 sys: 0.671
colNumber: 1093203 type: "replica_set" write_concern: "{w:1,j:true}" real: 165.971 user: 4.921 sys: 0.701
colNumber: 1093203 type: "replica_set" write_concern: "{w:1,j:true}" real: 171.172 user: 5.561 sys: 0.904
colNumber: 1093203 type: "replica_set" write_concern: "{w:1,j:true}" real: 172.437 user: 5.187 sys: 0.779
colNumber: 1093203 type: "replica_set" write_concern: "{w:2,j:false}" real: 177.76 user: 5.203 sys: 0.81
colNumber: 1093203 type: "replica_set" write_concern: "{w:2,j:false}" real: 169.324 user: 5.077 sys: 0.733
colNumber: 1093203 type: "replica_set" write_concern: "{w:2,j:false}" real: 167.232 user: 5.124 sys: 0.779
colNumber: 1093203 type: "replica_set" write_concern: "{w:2,j:false}" real: 165.557 user: 5.124 sys: 0.905
colNumber: 1093203 type: "replica_set" write_concern: "{w:2,j:false}" real: 168.834 user: 4.953 sys: 1.045
colNumber: 1093203 type: "replica_set" write_concern: "{w:2,j:true}" real: 177.623 user: 4.89 sys: 0.811
colNumber: 1093203 type: "replica_set" write_concern: "{w:2,j:true}" real: 169.502 user: 5.359 sys: 0.81
colNumber: 1093203 type: "replica_set" write_concern: "{w:2,j:true}" real: 169.383 user: 5.015 sys: 0.935
colNumber: 1093203 type: "replica_set" write_concern: "{w:2,j:true}" real: 166.713 user: 5.265 sys: 0.904
colNumber: 1093203 type: "replica_set" write_concern: "{w:2,j:true}" real: 165.661 user: 4.921 sys: 0.872
```

##### Vehicles
```
colNumber: 5805825 type: "replica_set" write_concern: "default" real: 806.913 user: 7.843 sys: 1.17
colNumber: 5805825 type: "replica_set" write_concern: "default" real: 745.585 user: 8.436 sys: 1.123
colNumber: 5805825 type: "replica_set" write_concern: "default" real: 753.301 user: 7.921 sys: 1.311
colNumber: 5805825 type: "replica_set" write_concern: "default" real: 780.457 user: 7.622 sys: 1.014
colNumber: 5805825 type: "replica_set" write_concern: "default" real: 778.687 user: 7.718 sys: 1.029
colNumber: 5805825 type: "replica_set" write_concern: "{w:1,j:false}" real: 808.388 user: 8.561 sys: 1.201
colNumber: 5805825 type: "replica_set" write_concern: "{w:1,j:false}" real: 808.41 user: 8.061 sys: 1.293
colNumber: 5805825 type: "replica_set" write_concern: "{w:1,j:false}" real: 755.805 user: 8.421 sys: 1.53
colNumber: 5805825 type: "replica_set" write_concern: "{w:1,j:false}" real: 778.222 user: 8.03 sys: 0.889
colNumber: 5805825 type: "replica_set" write_concern: "{w:1,j:false}" real: 708.17 user: 7.858 sys: 1.216
colNumber: 5805825 type: "replica_set" write_concern: "{w:1,j:true}" real: 803.449 user: 8.062 sys: 1.123
colNumber: 5805825 type: "replica_set" write_concern: "{w:1,j:true}" real: 879.786 user: 8.576 sys: 1.483
colNumber: 5805825 type: "replica_set" write_concern: "{w:1,j:true}" real: 830.773 user: 8.421 sys: 1.202
colNumber: 5805825 type: "replica_set" write_concern: "{w:1,j:true}" real: 833.747 user: 8.232 sys: 1.232
colNumber: 5805825 type: "replica_set" write_concern: "{w:1,j:true}" real: 751.964 user: 8.218 sys: 0.967
colNumber: 5805825 type: "replica_set" write_concern: "{w:2,j:false}" real: 854.942 user: 8.515 sys: 1.248
colNumber: 5805825 type: "replica_set" write_concern: "{w:2,j:false}" real: 863.634 user: 8.186 sys: 1.373
colNumber: 5805825 type: "replica_set" write_concern: "{w:2,j:false}" real: 760.854 user: 8.171 sys: 0.842
colNumber: 5805825 type: "replica_set" write_concern: "{w:2,j:false}" real: 750.956 user: 8.031 sys: 1.326
colNumber: 5805825 type: "replica_set" write_concern: "{w:2,j:false}" real: 755.747 user: 8.045 sys: 1.014
colNumber: 5805825 type: "replica_set" write_concern: "{w:2,j:true}" real: 866.3 user: 8.342 sys: 1.217
colNumber: 5805825 type: "replica_set" write_concern: "{w:2,j:true}" real: 863.676 user: 8.436 sys: 1.077
colNumber: 5805825 type: "replica_set" write_concern: "{w:2,j:true}" real: 759.791 user: 7.968 sys: 1.138
colNumber: 5805825 type: "replica_set" write_concern: "{w:2,j:true}" real: 765.004 user: 7.514 sys: 1.076
colNumber: 5805825 type: "replica_set" write_concern: "{w:2,j:true}" real: 762.74 user: 7.609 sys: 0.983
```

#### Wyniki pojedynczych importów w standalone
##### Mazowieckie
```
colNumber: 1093203 type: "standalone" write_concern: "default" real: 53.539 user: 5.14 sys: 0.765
colNumber: 1093203 type: "standalone" write_concern: "default" real: 57.946 user: 5.356 sys: 0.92
colNumber: 1093203 type: "standalone" write_concern: "default" real: 58.082 user: 5.421 sys: 0.92
colNumber: 1093203 type: "standalone" write_concern: "default" real: 59.251 user: 5.546 sys: 0.796
colNumber: 1093203 type: "standalone" write_concern: "default" real: 53.196 user: 5.468 sys: 0.982
```

##### Vehicles
```
colNumber: 5805825 type: "standalone" write_concern: "default" real: 209.39 user: 7.25 sys: 1.139
colNumber: 5805825 type: "standalone" write_concern: "default" real: 204.961 user: 7.671 sys: 1.247
colNumber: 5805825 type: "standalone" write_concern: "default" real: 208.459 user: 7.685 sys: 1.186
colNumber: 5805825 type: "standalone" write_concern: "default" real: 208.882 user: 7.843 sys: 0.906
colNumber: 5805825 type: "standalone" write_concern: "default" real: 209.456 user: 8.515 sys: 1.092
```

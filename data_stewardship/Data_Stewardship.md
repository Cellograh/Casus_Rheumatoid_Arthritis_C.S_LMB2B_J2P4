# Data Stewardship

## Belang van databeheer

Goed databeheer is een essentieel onderdeel van wetenschappelijk onderzoek. Het zorgt ervoor dat onderzoeksresultaten reproduceerbaar, controleerbaar en betrouwbaar zijn. 
Wanneer data en analyses goed georganiseerd zijn, kunnen andere onderzoekers of studenten de uitgevoerde stappen begrijpen en eventueel opnieuw uitvoeren.
Binnen dit project naar Reumatoïde Artritis worden grote hoeveelheden RNA-sequencinggegevens verwerkt. 
Zonder een duidelijke structuur bestaat het risico dat bestanden verloren gaan, analyses niet meer reproduceerbaar zijn of resultaten verkeerd geïnterpreteerd worden.
Daarnaast draagt goed databeheer bij aan de kwaliteit van onderzoek doordat fouten sneller worden ontdekt en analyses beter gecontroleerd kunnen worden.

---
## Duidelijke mappenstructuur

Een vaste mappenstructuur maakt het eenvoudiger om bestanden terug te vinden en voorkomt verwarring.
Voor dit project wordt bijvoorbeeld de volgende structuur gebruikt:

`main/`
  - `assets/`
  - `bronnen/`
  - `data/raw/`
  - `data/processed/`
  - `resultaten/`
  - `scripts/`
  - `data_stewardship/`

Waarom deze structuur?
- data/raw/   	       - bevat de originele RNA-sequencingbestanden (FASTQ-bestanden). Deze bestanden blijven altijd ongewijzigd zodat de oorspronkelijke data behouden blijft.
- data/processed/      - bevat bewerkte datasets zoals count matrix, en de samples na het sorteren en mappen.
- scripts/             - bevat alle gebruikte R-scripts voor de analyses, waaronder mapping, DESeq2-analyse, GO-analyse en KEGG-analyse.
- resultaten/          - bevat de gegenereerde output zoals PCA-plots, volcano plots, heatmaps en differentiële expressieresultaten.
- data_stewardship/    - bevat aanvullende documentatie zoals het Data Stewardship-document en informatie over GitHub-beheer.
- assets/              - bevat afbeeldingen die gebruikt worden in de README
- bronnen/             - bevat de literatuurlijst met gebruikte bronnen voor de theoretische achtergrond van het uitwerken van de casus

Door deze structuur worden ruwe data, analyses en resultaten van elkaar gescheiden, waardoor het project overzichtelijk en reproduceerbaar blijft.

---
## Naamgeving van bestanden
Consistente bestandsnamen maken het eenvoudiger om bestanden terug te vinden.

 benoemen van bestanden worden de volgende richtlijnen aangehouden:
  - Gebruik geen spaties.
  - Gebruik duidelijke en beschrijvende namen.
  - Gebruik underscores (_) om woorden te scheiden.

Een duidelijke naam maakt direct zichtbaar wat de inhoud van een bestand is.

---
## Versiebeheer

Versiebeheer houdt in dat veranderingen in bestanden worden bijgehouden. Hierdoor kan altijd worden teruggekeken naar eerdere versies van scripts, analyses en documentatie.
Voor dit project wordt gebruikgemaakt van Git en GitHub. Tijdens het uitvoeren van de analyses worden wijzigingen opgeslagen via commits. 
Hierdoor blijft inzichtelijk welke aanpassingen zijn gedaan en wanneer deze zijn uitgevoerd.

De voordelen van deze versiebeheer zijn:
  - Eerdere versies kunnen worden teruggezet.
  - Fouten kunnen eenvoudig worden hersteld.
  - Samenwerking wordt eenvoudiger.
  - De ontwikkeling van het project blijft inzichtelijk.
GitHub is hierbij een centrale opslagplaats voor scripts, documentatie en projectinformatie.
Deze casus is individueel uitgevoerd maar de versiebeheer van Git en Github zijn geschikt voor een goede samenwerking

---
## Documentatie van scripts

Om analyses reproduceerbaar te maken is goede documentatie van scripts essentieel. Iedere onderzoeker moet kunnen begrijpen welke stappen zijn uitgevoerd en waarom.
Scripts bevatten daarom beschrijvende uitleg, ook zijn de verschillende analyses zowel in het volledige script voorzien van kopjes als dat ze in map [scripts](scripts) per analyse nog los gedocumenteerd zijn.

Belangrijke onderdelen van scriptdocumentatie zijn:
  - Doel van het script.
  - Gebruikte packages.
  - Beschrijving van analyse-stappen.
  - Uitleg van belangrijke parameters.
  - Eventuele aannames of keuzes binnen de analyse.

Goede documentatie maakt het mogelijk om analyses later opnieuw uit te voeren of aan te passen.

---
## Platforms voor het delen van scripts 
Voor het delen van scripts en onderzoeksprojecten kunnen verschillende platforms worden gebruikt:
  - GitHub
  - GitLab
  - Bitbucket
Voor dit project wordt GitHub gebruikt als centrale locatie voor versiebeheer, documentatie en het delen van scripts. Hierdoor kunnen anderen de analyses bekijken, controleren en eventueel hergebruiken.

---
## Tools voor data-analyse en opslag

Binnen dit project worden verschillende bioinformatica- en data-analysetools gebruikt:
|Tool	| Functie |
|-----------|--------|
| R	| Statistische analyse en visualisatie |
| Rsubread | Read alignment en feature counting |
| DESeq2 |	Differentiële expressieanalyse |
| clusterProfiler |	GO- en KEGG-analyses |
| Pathview | Visualisatie van pathways |
| Git |	Versiebeheer |
| GitHub  |	Opslag en delen van scripts |

De [gebruikte packages](scripts/packages) zijn ook apart gedocumenteerd met bijbehorende versienummers en gebruikte packagebron
Naast GitHub is het belangrijk om regelmatig back-ups van data op een veilige opslaglocatie te bewaren om gegevensverlies te voorkomen. 
Gedurende deze casus zijn er back-ups gemaakt van alle scripten en datasets zowel op OneDrive als via interne opslag 

---
## Omgaan met gevoelige of persoonlijke data

Bij onderzoek met patiëntgegevens moet zorgvuldig worden omgegaan met privacygevoelige informatie.

Belangrijke maatregelen zijn:
  - Persoonsgegevens verwijderen of anonimiseren.
  - Data alleen toegankelijk maken voor bevoegde personen.
  - Gebruikmaken van beveiligde opslaglocaties.
  - Geen persoonsgegevens publiceren in openbare repositories.
  - Voldoen aan de Algemene Verordening Gegevensbescherming (AVG).

In dit project wordt gewerkt met openbare RNA-sequencingdata en worden geen direct herleidbare persoonsgegevens verwerkt. 
Wanneer patiëntinformatie wel beschikbaar zou zijn, moeten aanvullende beveiligingsmaatregelen worden genomen.

---
## Belang van open data en het publiceren van datasets

Open data speelt een belangrijke rol binnen de wetenschap. Door datasets en analyses openbaar beschikbaar te maken kunnen resultaten worden gecontroleerd, gevalideerd en hergebruikt.

Voordelen van open data zijn:
  - Verhoogde transparantie.
  - Betere reproduceerbaarheid van onderzoek.
  - Mogelijkheid tot validatie van resultaten.
  - Efficiënter gebruik van bestaande datasets.
  - Bevordering van wetenschappelijke samenwerking.

---
Binnen dit project wordt gebruikgemaakt van openbaar beschikbare [RNA-sequencingdata](data/raw). Hierdoor kunnen andere onderzoekers dezelfde analyses uitvoeren en controleren of vergelijkbare resultaten worden verkregen. 
Dit verhoogt de betrouwbaarheid van de onderzoeksuitkomsten.
Bij het publiceren van datasets moet echter altijd rekening worden gehouden met privacywetgeving en ethische richtlijnen.

Binnen dit transcriptomicsproject naar Reumatoïde Artritis draagt goed databeheer bij aan een overzichtelijke workflow, reproduceerbare analyses en betrouwbare resultaten. 
Door gebruik te maken van een duidelijke mappenstructuur, consistente bestandsnamen, versiebeheer via GitHub en uitgebreide documentatie blijven alle onderdelen van het onderzoek overzichtelijk en toegankelijk.
Daarnaast zorgen veilige opslag van data, zorgvuldig omgaan met gevoelige informatie en het gebruik van open data ervoor dat het onderzoek voldoet aan de principes van transparante en verantwoordelijke wetenschap. 
Hierdoor kunnen de uitgevoerde analyses niet alleen worden gecontroleerd, maar ook als basis dienen voor toekomstig onderzoek naar Reumatoïde Artritis.

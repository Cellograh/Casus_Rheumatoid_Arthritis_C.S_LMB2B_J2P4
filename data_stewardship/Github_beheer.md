# Github beheer

## Inleiding

Tijdens dit project is GitHub gebruikt als platform voor versiebeheer, documentatie en het organiseren van alle bestanden die nodig zijn voor de transcriptomicsanalyse van Reumatoïde Artritis. 
GitHub maakt het mogelijk om analyses, resultaten en documentatie centraal op te slaan en wijzigingen gedurende het project bij te houden.
Door gebruik te maken van GitHub wordt het onderzoek transparanter en beter reproduceerbaar. Andere onderzoekers of studenten kunnen de gebruikte workflow bekijken, scripts controleren en analyses opnieuw uitvoeren.

---
## Bijdrage aan reproduceerbaarheid

Reproduceerbaarheid is een belangrijk onderdeel van wetenschappelijk onderzoek. Een onderzoek wordt reproduceerbaar genoemd wanneer anderen dezelfde stappen kunnen uitvoeren en vergelijkbare resultaten kunnen verkrijgen.

Binnen deze repository wordt dit ondersteund door:
  - Het beschikbaar maken van alle gebruikte [scripts](scripts/Script_project_Transcriptomics.R) .
  - Het documenteren van de volledige [analyseworkflow](assets/FlowchartRA.png) in de README.
  - Het scheiden van [ruwe data](data/raw), [scripts](scripts) en [resultaten](resultaten).
  - Het beschrijven van gebruikte software en analysemethoden.
  - Het opslaan van gegenereerde figuren en resultaten.

De README beschrijft stap voor stap hoe de analyse is uitgevoerd, vanaf de [FASTQ-bestanden](data/raw) tot en met de [differentiële expressieanalyse]{scripts/DESeq2), [GO-analyse](scripts.GO_analyse) en [KEGG-analyse](KEGG). 
Hierdoor kan een andere gebruiker de [workflow](assets/FlowchartRA.png) volgen en opnieuw uitvoeren.
Daarnaast is een workflowdiagram opgenomen waarmee de volledige analyseketen overzichtelijk wordt weergegeven.

---
## Overzichtelijke structuur van de repository

Om het project overzichtelijk te houden is een duidelijke mappenstructuur aangehouden. Deze mappenstructuur zichtbaar en omschreven in het [Data_stewardship](data_stewardship/Data_Stewardship) document 
Iedere map heeft een specifieke functie, door deze indeling kunnen bestanden eenvoudig worden teruggevonden en blijft duidelijk welke bestanden bij welke stap van het onderzoek horen.

---
## Gebruiksvriendelijkheid voor andere onderzoekers

De repository is zo ingericht dat een andere gebruiker het onderzoek eenvoudig kan begrijpen.

Hiervoor zijn verschillende maatregelen genomen:
  - Een uitgebreide README met uitleg van het project.
  - Een inhoudsopgave voor snelle navigatie.
  - Beschrijvingen van gebruikte analysemethoden.
  - Duidelijke verwijzingen naar scripts en resultaten.
  - Logische naamgeving van bestanden en mappen.

Hierdoor hoeft een gebruiker niet zelf uit te zoeken welke bestanden gebruikt zijn tijdens de analyse. De belangrijkste informatie is direct beschikbaar vanuit de hoofdpagina van de repository.

---
## Versiebeheer met Git

Tijdens het project is gebruikgemaakt van Git voor versiebeheer. Git houdt wijzigingen in bestanden bij zodat eerdere versies altijd kunnen worden teruggevonden.

Voorbeelden van wijzigingen die tijdens het project kunnen worden opgeslagen zijn:
  - Toevoegen van een nieuwe analyse.
  - Aanpassen van een script.
  - Verbeteren van een visualisatie.
  - Uitbreiden van de documentatie.
Doormiddel van commits wordt vastgelegd welke wijzigingen zijn uitgevoerd. Hierdoor ontstaat een overzichtelijke geschiedenis van het project.

Voordelen hiervan zijn:
  - Fouten kunnen eenvoudig worden teruggedraaid.
  - Eerdere versies blijven beschikbaar.
  - Ontwikkeling van het project blijft inzichtelijk.
  - Samenwerking met andere onderzoekers wordt eenvoudiger.
    
GitHub is hierbij een centrale opslagplaats waarin alle wijzigingen worden bijgehouden.

---
## Documentatie

Goede documentatie is essentieel voor een bruikbare GitHub-repository.

Binnen dit project wordt documentatie verzorgd door:
  - De README op de hoofdpagina.
  - Het Data Stewardship-document.
  - Dit GitHub Beheer-document.
  - Commentaarregels in scripts.

Hierdoor wordt niet alleen duidelijk wat er gedaan is, maar ook waarom bepaalde keuzes zijn gemaakt.

---
GitHub heeft binnen dit project een belangrijke rol gespeeld bij het organiseren van bestanden, het beheren van versies en het documenteren van de uitgevoerde analyses. 
Door een duidelijke mappenstructuur, uitgebreide documentatie en het gebruik van versiebeheer is de repository overzichtelijk en reproduceerbaar gemaakt.
Een andere onderzoeker kan hierdoor de gebruikte workflow volgen, scripts opnieuw uitvoeren en de resultaten controleren. 
Daarmee draagt GitHub direct bij aan de betrouwbaarheid, transparantie en herbruikbaarheid van het onderzoek naar Reumatoïde Artritis.

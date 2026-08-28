# *Transcriptomicsanalyse van verschillen in genexpressie bij patiënten met Reumatoïde Artritis ten opzichte van gezonde controles*
<p align="center">
  <img src="assets/Rheumatoid_Arthritis_Titleimage.png" alt="RAtitle" width="800"/>
</p>

*Afbeelding afkomstig van Khopde (2025), Manipal Hospitals Baner.*

---
## Introductie
Dit project onderzoekt verschillen in genexpressie tussen gezonde individuen en patiënten met Reumatoïde Artritis (RA) met behulp van [RNA-sequencing data](data/raw). Doormiddel van differentiële expressieanalyse is onderzocht welke genen significant verhoogd (upregulated) of verlaagd (downregulated) tot expressie komen bij RA-patiënten. Daarnaast zijn functionele analyses uitgevoerd om biologische processen en signaalroutes te identificeren die betrokken zijn bij de ziekte.

---
## Inhoudsopgave
- [1. Inleiding](#inleiding)
- [2. Methode](#methode)
- [3. Workflow](#workflow)
- [4. Resultaten](#resultaten)
    - 4.1 `PCA-plot`
    - 4.2 `DESeq2-analyse`
    - 4.3 `volcano plot`
    - 4.4 `heatmap`
    - 4.5 `KEGG pathway enrichment analyse`
    - 4.6 `GO-analyse`
    - 4.7 `gene pathway analysis`
- [5. Conclusie](#conclusie)
- [6. Data Stewardship](#data-stewardship)
- [7. Github beheer](#github-beheer)
- [8. Referenties](#referenties)


---
<a id="inleiding"></a>
## 1. Inleiding
Reumatoïde Artritis (RA) is een chronische auto-immuunziekte die wordt gekenmerkt door ontsteking van de synoviale gewrichten, wat uiteindelijk kan leiden tot kraakbeenafbraak, boterosie en blijvende gewrichtsschade. Wereldwijd wordt ongeveer 0,5–1% van de bevolking getroffen door RA, waardoor de ziekte een belangrijke oorzaak vormt van chronische pijn en verminderde levenskwaliteit. Hoewel de precieze oorzaak van RA nog niet volledig bekend is, speelt ontregeling van het immuunsysteem een centrale rol in de ontwikkeling en progressie van de ziekte. Onderzoek heeft aangetoond dat zowel B-cellen, T-cellen, macrofagen als verschillende cytokinen betrokken zijn bij het onderhouden van de chronische ontstekingsreactie die kenmerkend is voor RA [[3,4]](bronnen/Literatuurlijst_RA.pdf).
De afgelopen jaren heeft transcriptomics een belangrijke bijdrage geleverd aan het begrijpen van de moleculaire mechanismen achter RA. Door genexpressieprofielen van patiënten en gezonde controles met elkaar te vergelijken kunnen differentieel geëxprimeerde genen (DEGs) worden geïdentificeerd die betrokken zijn bij ontstekingsprocessen, immuunregulatie en ziekteprogressie [[1,5]](bronnen/Literatuurlijst_RA.pdf). Eerdere bio-informatica studies rapporteerden sterke veranderingen in genen die betrokken zijn bij TNF-signaling, IL-17-signaling, B-celactivatie en adaptieve immuunresponsen[[1,2,4]](bronnen/Literatuurlijst_RA.pdf).

Het doel van dit onderzoek is om verschillen in genexpressie tussen gezonde individuen en patiënten met Reumatoïde Artritis te identificeren met behulp van RNA-sequencing data. Daarnaast wordt onderzocht welke genen significant upregulated of downregulated zijn en welke biologische processen en signaalroutes betrokken zijn bij de waargenomen transcriptomische veranderingen.
### Onderzoeksvraag

Welke genen hebben significante differentiele expressie tussen gezonde individuen en patiënten met Reumatoïde Artritis en welke biologische processen en pathways zijn betrokken bij deze veranderingen?

---

<a id="methode"></a>
## 2. Methode
### 2.1 Dataset en ruwe RNA-sequencingdata
Voor deze transcriptomicsanalyse werd gebruikgemaakt van RNA-sequencingdata van vier gezonde controles en vier patiënten met Reumatoïde Artritis (RA). De gebruikte dataset is afkomstig uit de studie van Platzer et al. (2019), waarin RNA-sequencingdata van verschillende RA-gerelateerde patiëntgroepen en gezonde controles werden verzameld en geanalyseerd. De [oorspronkelijke RNA-seqdata](data/raw) werden door de auteurs verkregen via de Sequence Read Archive (SRA) [[11]](bronnen/Literatuurlijst_RA.pdf) .
De specifieke accessionnummers van de in deze analyse gebruikte ruwe datasets zijn weergegeven in de tabel 1. Hierdoor kunnen de gebruikte RNA-sequencingdata opnieuw worden geïdentificeerd en verkregen.
Voor een volledige beschrijving van de oorspronkelijke patiëntpopulaties, weefselbron, RNA-sequencingdata en dataverwerking wordt verwezen naar Platzer et al. (2019).


<strong>Tabel 1:</strong> *accession nummers van ruwe RNA-seq datasets*
| Sample | SRA accession nummer | Sequencing bestanden |
|:---|:---:|:---|
| RA1 | SRR4785819 | SRR4785819_1_subset40k.fastq en SRR4785819_2_subset40k.fastq |
| RA2 | SRR4785820 | SRR4785820_1_subset40k.fastq en SRR4785820_2_subset40k.fastq |
| RA3 | SRR4785828 | SRR4785828_1_subset40k.fastq en SRR4785828_2_subset40k.fastq |
| RA4 | SRR4785831 | SRR4785831_1_subset40k.fastq en SRR4785831_2_subset40k.fastq |
| RA5 | SRR4785979 | SRR4785979_1_subset40k.fastq en SRR4785979_2_subset40k.fastq |
| RA6 | SRR4785980 | SRR4785980_1_subset40k.fastq en SRR4785980_2_subset40k.fastq |
| RA7 | SRR4785986 | SRR4785986_1_subset40k.fastq en SRR4785986_2_subset40k.fastq |
| RA8 | SRR4785988 | SRR4785988_1_subset40k.fastq en SRR4785988_2_subset40k.fastq |

### 2.2 Read mapping en genkwantificatie
De paired-end reads werden [gemapt](scripts/mapping) tegen het humane referentiegenoom GRCh38.p14 (NCBI accession GCF_000001405.40)[[6]](bronnen/Literatuurlijst_RA.pdf) met behulp van het Rsubread-pakket [[8]](bronnen/Literatuurlijst_RA.pdf). De gebruikte versie van Rsubread is opgenomen in de tabel met software- en packageversies. Na mapping werden de reads per gen geteld met FeatureCounts [[7]](bronnen/Literatuurlijst_RA.pdf). De resulterende gen-tellingen werden samengevoegd tot een count matrix die als input werd gebruikt voor de differentiële expressieanalyse.
### 2.3 Differentiële genexpressie
[De differentiële genexpressie](scripts/DESeq2) tussen de RA-groep en de gezonde controlegroep werd bepaald met het R/Bioconductor-pakket DESeq2 [[9]](bronnen/Literatuurlijst_RA.pdf). Hierbij werd de experimentele conditie gebruikt als verklarende variabele. DESeq2 modelleert read counts met een negatief binomiaal model. Voor multiple-testingcorrectie werd de Benjamini-Hochbergmethode toegepast.

> Een adjusted p-value (padj) < 0,05 werd gebruikt als criteria voor statistische significantie. Daarnaast werd een absolute log2 fold change (log2FC) > 1 gebruikt als criteria voor een verandering van minimaal een factor twee in genexpressie. De padj beschrijft hierbij de statistische significantie van een verschil, terwijl de log2FC de omvang en richting van de verandering beschrijft.

De volledige scripts voor de read mapping, genkwantificatie en DESeq2-analyse zijn afzonderlijk beschikbaar in de map [scripts](scripts/). In ieder script wordt beschreven welke inputbestanden worden gebruikt, welke analyse wordt uitgevoerd en welke output wordt gegenereerd.
### 2.4 Kwaliteitscontrole en visualisatie
Om de globale overeenkomst en verschillen tussen de RNA-sequencingmonsters te beoordelen werd [Principal Component Analysis (PCA)](scripts/DESeq2) uitgevoerd. Daarnaast werd een [heatmap](scripts/Heatmap) gemaakt van de 50 meest significant differentieel geëxprimeerde genen. Deze visualisatie werd gebruikt om te beoordelen of monsters met dezelfde experimentele conditie vergelijkbare genexpressieprofielen vertoonden.
Een volcano plot werd gebruikt om de relatie tussen de omvang van de expressieverandering (log2FC) en de statistische significantie (-log10 adjusted p-value) van de onderzochte genen weer te geven.
### 2.5 Gene Ontology-analyse
Om te onderzoeken welke biologische processen geassocieerd waren met de differentieel geëxprimeerde genen werd een [Gene Ontology (GO) enrichmentanalyse](scripts/GO_analyse) uitgevoerd. Hierbij werd specifiek gekeken naar de GO-categorie Biological Process (BP). De analyse werd uitgevoerd met clusterProfiler [[12]](bronnen/Literatuurlijst_RA.pdf), waarbij de geselecteerde differentieel geëxprimeerde genen als input werden gebruikt.
De verrijking werd beoordeeld op basis van de adjusted p-value. De belangrijkste verrijkte GO-termen werden vervolgens gevisualiseerd met een dotplot. De gebruikte parameters, packageversies en scripts zijn terug te vinden in de bijbehorende analysebestanden.
### 2.6 KEGG pathway enrichmentanalyse
Naast GO werd een [KEGG pathway enrichmentanalyse](scripts/KEGG) uitgevoerd om te bepalen welke biologische signaalroutes oververtegenwoordigd waren onder de differentieel geëxprimeerde genen. De analyse werd uitgevoerd met clusterProfiler [[12]](bronnen/Literatuurlijst_RA.pdf). De verrijkte pathways werden beoordeeld op basis van de adjusted p-value en weergegeven met een dotplot.
De pathways die relevant waren voor de onderzoeksvraag werden geselecteerd voor verdere visualisatie met Pathview.
### 2.7 Pathwayvisualisatie met Pathview
Om de locatie van differentieel geëxprimeerde genen binnen specifieke biologische pathways te visualiseren werd het R-pakket Pathview [[10]](bronnen/Literatuurlijst_RA.pdf) gebruikt. De volgende KEGG pathways werden gevisualiseerd:
- Rheumatoid arthritis — hsa05323
- IL-17 signaling pathway — hsa04657
- TNF signaling pathway — hsa04668
  
De kleur van de genen in de Pathviewvisualisaties geeft de richting van de expressieverandering weer, waarbij rood staat voor verhoogde expressie en groen voor verlaagde expressie in de RA-groep ten opzichte van de gezonde controles.
De gebruikte scripts en outputbestanden van de GO-, KEGG- en Pathviewanalyses zijn afzonderlijk beschikbaar in de map [scripts](scripts/) en [resultaten](resultaten/).

---
<a id="workflow"></a>
## 3. Workflow

![flowchart](assets/FlowchartRA.png)

<p align="center">
  <strong>Figuur 1:</strong> <em>Overzicht van de uitgevoerde transcriptomische analyseworkflow.</em>
</p>


---
<a id="resultaten"></a>
## 4. Resultaten
### 4.1 RA- en controlegroep vertonen verschillende transcriptomische profielen

<p align="center">
  <img src="resultaten/PCAplot.png" alt="PCA-analyse">
</p>

<p align="center">
  <strong>Figuur 2;</strong> <em>Principal Component Analysis (PCA) van RNA-sequencingmonsters van vier gezonde controles en vier patiënten met Reumatoïde Artritis. De positie van ieder punt vertegenwoordigt het globale genexpressieprofiel van één monster. PC1 en PC2 zijn 74% en 10% van de totale variantie.</em>
</p>


De [PCA](scripts/DESeq2) werd uitgevoerd om te beoordelen of de monsters op basis van hun globale genexpressieprofiel van elkaar verschilden en of de RA- en controlegroepen afzonderlijk clusteren.
De PCA liet een duidelijke scheiding zien tussen de gezonde controles en RA-patiënten. PC1 verklaarde 74% van de totale variantie en PC2 verklaarde 10%, waardoor de eerste twee componenten gezamenlijk ongeveer 84% van de variantie verklaarden. De monsters van de gezonde controles en RA-patiënten vormden afzonderlijke clusters. Dit wijst erop dat de twee onderzoeksgroepen duidelijke verschillen vertonen in hun globale transcriptomische profiel.

---
### 4.2 Differentieel geëxprimeerde genen onderscheiden de twee onderzoeksgroepen
Met DESeq2 werd onderzocht welke genen statistisch significant verschillend tot expressie kwamen tussen patiënten met RA en gezonde controles.
De [DESeq2-analyse](scripts/DESeq2) identificeerde 4.572 differentieel geëxprimeerde genen op basis van de vooraf vastgestelde selectiecriteria. Hiervan waren 2.085 genen verhoogd en 2.487 genen verlaagd geëxprimeerd in de RA-groep ten opzichte van de gezonde controles.
  
<strong>Tabel 2:</strong> *samenvatting DESeq2-resultaten*
| Resultaat | Aantal |
|------------|--------:|
| Totaal geanalyseerde genen | 29407 |
| Significant differentieel geëxprimeerde genen | 4572 |
| Upregulated genen | 2085 |
| Downregulated genen | 2487 |

De analyse toont aan dat een groot aantal genen significant verschillend tot expressie komt tussen gezonde individuen en RA-patiënten. Dit bevestigt dat Reumatoïde Artritis gepaard gaat met aanwezige veranderingen in genexpressie, deze expressie wordt zowel verhoogd (upregulated) of verlaagd (downregulated).

<p align="center">
  <img src="resultaten/volcanoplot.png" alt="volcanoplot">
</p>
<p align="center">
  <strong>Figuur 3:</strong> <em>Volcano plot van de differentieel geëxprimeerde genen tussen vier gezonde controles en vier patiënten met Reumatoïde Artritis. De x-as toont de log2 fold change en de y-as de -log10 van de adjusted p-value. Genen rechts van nul hebben een hogere expressie in de RA-groep en genen links van nul een lagere expressie. De vooraf vastgestelde criteria voor differentiële expressie zijn gebruikt om significante genen te identificeren.</em>
</p>

De [volcano plot](scripts/Volcanoplot) laat zien dat de differentieel geëxprimeerde genen zich aan beide zijden van de log2FC-as bevinden. De verhoogd geëxprimeerde genen bevinden zich aan de rechterzijde en de verlaagd geëxprimeerde genen aan de linkerzijde. Hiermee wordt zichtbaar dat de transcriptomische verschillen tussen de groepen zowel uit verhoogde als verlaagde genexpressie bestaan.
Onder de sterk verhoogd geëxprimeerde genen bevonden zich meerdere immunoglobulinegenen, waaronder IGHV4-4, IGHV3-53, IGKJ2 en IGLV1-47. Deze bevinding vormt een eerste aanwijzing voor een verschil in immuungerelateerde genexpressie tussen beide groepen.


---
### 4.3 Differentieel geëxprimeerde genen onderscheiden de twee onderzoeksgroepen
De [heatmap](scripts/Heatmap) werd gebruikt om te beoordelen of de meest significant differentieel geëxprimeerde genen een consistent expressiepatroon tussen de monsters vertonen.

<p align="center">
  <img src="resultaten/heatmapplot.png" alt="heatmap">
</p>
<p align="center">
  <strong>Figuur 4:</strong> <em>Heatmap van de 50 meest significant differentieel geëxprimeerde genen in vier gezonde controles en vier patiënten met Reumatoïde Artritis. Iedere rij vertegenwoordigt een gen en iedere kolom een RNA-sequencingmonster. De kleurintensiteit geeft de relatieve genexpressie weer volgens de gebruikte schaalverdeling. De clustering van monsters laat zien in hoeverre de transcriptomische profielen tussen de groepen overeenkomen.</em>
</p>

De heatmap van de 50 meest significante differentieel geëxprimeerde genen liet een duidelijke clustering zien. De gezonde controles en RA-patiënten vormden afzonderlijke clusters, waarbij de expressiepatronen binnen iedere groep onderling meer overeenkwamen dan tussen de groepen. Dit ondersteunt de bevinding uit de PCA dat de twee onderzoeksgroepen duidelijke verschillen in genexpressie vertonen.

---
### 4.4 Differentieel geëxprimeerde genen zijn sterk betrokken bij adaptieve immuniteit
De [GO Biological Process-analyse](scripts/GO_analyse) werd uitgevoerd om te bepalen welke biologische processen oververtegenwoordigd waren onder de differentieel geëxprimeerde genen.
In totaal werden 323 significant verrijkte biologische processen geïdentificeerd. De sterkst vertegenwoordigde processen waren voornamelijk gerelateerd aan adaptieve immuniteit, lymfocytfunctie en immuunreceptoractiviteit. De belangrijkste significant verrijkte biologische processen zijn zichtbaar in tabel 4

<strong>Tabel 3:</strong> *Belangrijkste significant verrijkte GO Biological Process-termen. Het aantal genen geeft aan hoeveel van de differentieel geëxprimeerde genen aan iedere GO-term waren gekoppeld. De termen zijn geselecteerd op basis van de verrijkingsanalyse*
| GO Biological Process | Genen |
|----------------------|-------:|
| Adaptive immune response based on somatic recombination of immune receptors | 152 |
| Lymphocyte differentiation | 161 |
| Immune response-regulating cell surface receptor signaling pathway | 140 |
| B cell mediated immunity | 88 |
| Immunoglobulin mediated immune response | 87 |
| Lymphocyte mediated immunity | 139 |
| Antigen receptor-mediated signaling pathway | 89 |
| T cell differentiation | 119 |
| Leukocyte mediated immunity | 160 |
| B cell activation | 104 |


De meest significante GO-term was adaptive immune response based on somatic recombination of immune receptors built from immunoglobulin superfamily domains, waarin 152 genen betrokken waren (adjusted p-value = 7,07 × 10⁻¹²). Daarnaast werden onder andere lymphocyte differentiation (161 genen), immune response-regulating cell surface receptor signaling pathway (140 genen), B cell mediated immunity (88 genen) en B cell activation (104 genen) sterk vertegenwoordigd. De GO-analyse wijst daarmee op een sterke betrokkenheid van adaptieve immuunresponsen, waaronder B-cel- en lymfocytgerelateerde processen.

---
### 4.5 Ontstekings- en immuungerelateerde pathways zijn verrijkt in RA

De [KEGG pathway enrichmentanalyse](scripts/KEGG) werd uitgevoerd om te bepalen welke biologische signaalroutes geassocieerd waren met de differentieel geëxprimeerde genen.
De verrijkte pathways waren voornamelijk gerelateerd aan immuunregulatie en ontstekingsprocessen. Onder de relevante pathways bevonden zich Rheumatoid arthritis, IL-17 signaling pathway en TNF signaling pathway. Deze resultaten sluiten aan bij de GO-analyse, waarin eveneens een sterke vertegenwoordiging van immuun- en ontstekingsgerelateerde processen werd gevonden.

<p align="center">
  <img src="resultaten/dotplotkegg.png" alt="KEGG Dotplot">
</p>
<p align="center">
  <strong>Figuur 5:</strong> <em>Dotplot van de meest significant verrijkte KEGG pathways op basis van de differentieel geëxprimeerde genen. De weergegeven pathways zijn gerangschikt op basis van de verrijkingsresultaten. De grootte en kleur van de punten geven de in de analyse gebruikte maatstaven voor respectievelijk het aantal betrokken genen en de statistische significantie weer.</em>
</p>

De KEGG-resultaten geven daarmee aan dat de waargenomen transcriptomische verschillen niet alleen op het niveau van individuele genen aanwezig zijn, maar ook samenkomen in biologische signaalroutes die betrokken zijn bij de immuunrespons en ontsteking.

---
### 4.6 Differentiale genexpressie is zichtbaar binnen RA-, IL-17- en TNF-pathways

[Pathview](scripts/Pathview) werd gebruikt om de differentieel geëxprimeerde genen binnen geselecteerde KEGG pathways op pathwayniveau te visualiseren en daarmee te onderzoeken waar binnen deze pathways expressieveranderingen optreden.
De Rheumatoid arthritis pathway (hsa05323) liet meerdere differentieel geëxprimeerde genen zien, waarmee de resultaten van de KEGG enrichmentanalyse op pathwayniveau werden weergegeven. Ook binnen de IL-17 signaling pathway (hsa04657) en de TNF signaling pathway (hsa04668) werden meerdere genen met veranderde expressie waargenomen. De pathviews vam deze 3 pathways zijn zichtbaar in figuur 6, 7 en 8.

<p align="center">
  <img src="resultaten/RA.pathview.png" alt="Rheumatoid Arthritis Pathway">
</p>
<p align="center">
  <strong>Figuur 6:</strong>  <em>Pathview-visualisatie van de Rheumatoid arthritis pathway (KEGG hsa05323) op basis van differentieel geëxprimeerde genen tussen vier gezonde controles en vier RA-patiënten. Rode en groene kleuren geven de richting van de expressieverandering weer volgens de legenda van de visualisatie.</em>
</p>


<p align="center">
  <img src="resultaten/IL17.pathview.png" alt="IL-17 Signaling Pathway">
</p>
<p align="center">
  <strong>Figuur 7:</strong> <em>Pathview-visualisatie van de IL-17 signaling pathway (KEGG hsa04657) op basis van differentieel geëxprimeerde genen tussen de RA- en controlegroep.</em>
</p>



<p align="center">
  <img src="resultaten/TNFsignaling.pathview.png" alt="TNF Signaling Pathway">
</p>
<p align="center">
  <strong>Figuur 8:</strong> <em>Pathview-visualisatie van de TNF signaling pathway (KEGG hsa04668) op basis van differentieel geëxprimeerde genen tussen de RA- en controlegroep.</em>
</p>


De drie Pathviewvisualisaties ondersteunen daarmee de KEGG-resultaten, waarin immuun- en ontstekingsgerelateerde pathways als relevante pathways naar voren kwamen. De resultaten wijzen met name op betrokkenheid van RA-gerelateerde, IL-17- en TNF-signaling in de gevonden transcriptomische verschillen.

---
<a id="conclusie"></a>
## 5. Conclusie

In dit onderzoek zijn transcriptomische verschillen tussen gezonde individuen en patiënten met Reumatoïde Artritis (RA) onderzocht met behulp van RNA-sequencing. De analyse identificeerde in totaal 4572 significant differentieel geëxprimeerde genen, waarvan 2085 genen verhoogd en 2487 genen verlaagd tot expressie kwamen in de RA-groep. Deze resultaten tonen aan dat RA gepaard gaat met omvangrijke veranderingen in genexpressie en bevestigen dat de ziekte een sterke moleculaire impact heeft op het immuunsysteem. De gevonden upregulated genen waren voornamelijk betrokken bij immuunactivatie, cytokinesignalering en antilichaamproductie. Daarnaast lieten de GO- en KEGG-analyses een duidelijke verrijking zien van biologische processen en pathways die verband houden met adaptieve immuniteit, B-celgemedieerde immuunresponsen, TNF-signaling en IL-17-signaling. Deze bevindingen sluiten nauw aan bij bestaande wetenschappelijke literatuur, waarin ontregeling van B-cellen, T-cellen en pro-inflammatoire cytokinen wordt beschreven als een centraal mechanisme in de pathogenese van Reumatoïde Artritis.

Hoewel de resultaten duidelijke verschillen tussen beide groepen aantonen, heeft dit onderzoek ook beperkingen. Het aantal onderzochte monsters was relatief klein, waardoor individuele variatie mogelijk invloed heeft gehad op de resultaten. Daarnaast zijn de bevindingen uitsluitend gebaseerd op bio-informatica analyses en zijn de gevonden genexpressieveranderingen niet experimenteel gevalideerd.
Toekomstig onderzoek zou zich kunnen richten op het analyseren van grotere patiëntgroepen en het valideren van de meest significante genen met technieken zoals qPCR of eiwitexpressie-analyses. Daarnaast kunnen de geïdentificeerde genen en pathways worden onderzocht als potentiële biomarkers of therapeutische aangrijpingspunten. Daarmee draagt dit onderzoek bij aan een beter begrip van de moleculaire mechanismen achter Reumatoïde Artritis en biedt het aanknopingspunten voor verdere ontwikkeling van gepersonaliseerde behandelstrategieën.

<a id="data-stewardship"></a>
## 6. Data Stewardship

Zie: [Data Stewardship](data_stewardship/Data_Stewardship.md) 

<a id="github-beheer"></a>
## 7. GitHub Beheer

Zie: [GitHub beheer](data_stewardship/Github_beheer.md)

<a id="referenties"></a>
## 8. Referenties
Zie: [Literatuurlijst](bronnen/Literatuurlijst_RA.pdf)




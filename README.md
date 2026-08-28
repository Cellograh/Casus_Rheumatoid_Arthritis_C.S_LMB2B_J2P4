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
- [Inleiding](#inleiding)
- [Methode](#methode)
- [Workflow](#workflow)
- [Resultaten](#resultaten)
    - `PCA-plot`
    - `DESeq2-analyse`
    - `volcano plot`
    - `heatmap`
    - `KEGG pathway enrichment analyse`
    - `GO-analyse`
    - `gene pathway analysis`
- [Conclusie](#conclusie)
- [Data Stewardship](#data-stewardship)
- [Github beheer](#github-beheer)
- [Referenties](#referenties)


---
<a id="inleiding"></a>
## Inleiding
Reumatoïde Artritis (RA) is een chronische auto-immuunziekte die wordt gekenmerkt door ontsteking van de synoviale gewrichten, wat uiteindelijk kan leiden tot kraakbeenafbraak, boterosie en blijvende gewrichtsschade. Wereldwijd wordt ongeveer 0,5–1% van de bevolking getroffen door RA, waardoor de ziekte een belangrijke oorzaak vormt van chronische pijn en verminderde levenskwaliteit. Hoewel de precieze oorzaak van RA nog niet volledig bekend is, speelt ontregeling van het immuunsysteem een centrale rol in de ontwikkeling en progressie van de ziekte. Onderzoek heeft aangetoond dat zowel B-cellen, T-cellen, macrofagen als verschillende cytokinen betrokken zijn bij het onderhouden van de chronische ontstekingsreactie die kenmerkend is voor RA [[3,4]](bronnen/Literatuurlijst_RA.pdf).
De afgelopen jaren heeft transcriptomics een belangrijke bijdrage geleverd aan het begrijpen van de moleculaire mechanismen achter RA. Door genexpressieprofielen van patiënten en gezonde controles met elkaar te vergelijken kunnen differentieel geëxprimeerde genen (DEGs) worden geïdentificeerd die betrokken zijn bij ontstekingsprocessen, immuunregulatie en ziekteprogressie [[1,5]](bronnen/Literatuurlijst_RA.pdf). Eerdere bio-informatica studies rapporteerden sterke veranderingen in genen die betrokken zijn bij TNF-signaling, IL-17-signaling, B-celactivatie en adaptieve immuunresponsen[[1,2,4]](bronnen/Literatuurlijst_RA.pdf).

Het doel van dit onderzoek is om verschillen in genexpressie tussen gezonde individuen en patiënten met Reumatoïde Artritis te identificeren met behulp van RNA-sequencing data. Daarnaast wordt onderzocht welke genen significant upregulated of downregulated zijn en welke biologische processen en signaalroutes betrokken zijn bij de waargenomen transcriptomische veranderingen.
### Onderzoeksvraag

Welke genen hebben significante differentiele expressie tussen gezonde individuen en patiënten met Reumatoïde Artritis en welke biologische processen en pathways zijn betrokken bij deze veranderingen?

---

<a id="methode"></a>
## Methode
### Dataset en ruwe RNA-sequencingdata
Voor deze transcriptomicsanalyse werd gebruikgemaakt van RNA-sequencingdata van vier gezonde controles en vier patiënten met Reumatoïde Artritis (RA). De gebruikte dataset is afkomstig uit de studie van Platzer et al. (2019), waarin RNA-sequencingdata van verschillende RA-gerelateerde patiëntgroepen en gezonde controles werden verzameld en geanalyseerd. De [oorspronkelijke RNA-seqdata](data/raw) werden door de auteurs verkregen via de Sequence Read Archive (SRA) [[11]](bronnen/Literatuurlijst_RA.pdf) .
De specifieke accessionnummers van de in deze analyse gebruikte ruwe datasets zijn weergegeven in de tabel 1. Hierdoor kunnen de gebruikte RNA-sequencingdata opnieuw worden geïdentificeerd en verkregen.
Voor een volledige beschrijving van de oorspronkelijke patiëntpopulaties, weefselbron, RNA-sequencingdata en dataverwerking wordt verwezen naar Platzer et al. (2019).


*Tabel 1: accession nummers van ruwe RNA-seq datasets*
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

### Read mapping en genkwantificatie
De paired-end reads werden [gemapt](scripts/mapping) tegen het humane referentiegenoom GRCh38.p14 (NCBI accession GCF_000001405.40)[[6]](bronnen/Literatuurlijst_RA.pdf) met behulp van het Rsubread-pakket [[8]](bronnen/Literatuurlijst_RA.pdf). De gebruikte versie van Rsubread is opgenomen in de tabel met software- en packageversies. Na mapping werden de reads per gen geteld met FeatureCounts [[7]](bronnen/Literatuurlijst_RA.pdf). De resulterende gen-tellingen werden samengevoegd tot een count matrix die als input werd gebruikt voor de differentiële expressieanalyse.
### Differentiële genexpressie
[De differentiële genexpressie](scripts/DESeq2) tussen de RA-groep en de gezonde controlegroep werd bepaald met het R/Bioconductor-pakket DESeq2 [[9]](bronnen/Literatuurlijst_RA.pdf). Hierbij werd de experimentele conditie gebruikt als verklarende variabele. DESeq2 modelleert read counts met een negatief binomiaal model. Voor multiple-testingcorrectie werd de Benjamini-Hochbergmethode toegepast.

> Een adjusted p-value (padj) < 0,05 werd gebruikt als criteria voor statistische significantie. Daarnaast werd een absolute log2 fold change (log2FC) > 1 gebruikt als criteria voor een verandering van minimaal een factor twee in genexpressie. De padj beschrijft hierbij de statistische significantie van een verschil, terwijl de log2FC de omvang en richting van de verandering beschrijft.

De volledige scripts voor de read mapping, genkwantificatie en DESeq2-analyse zijn afzonderlijk beschikbaar in de map [scripts](scripts/). In ieder script wordt beschreven welke inputbestanden worden gebruikt, welke analyse wordt uitgevoerd en welke output wordt gegenereerd.
### Kwaliteitscontrole en visualisatie
Om de globale overeenkomst en verschillen tussen de RNA-sequencingmonsters te beoordelen werd [Principal Component Analysis (PCA)](scripts/DESeq2) uitgevoerd. Daarnaast werd een [heatmap](scripts/Heatmap) gemaakt van de 50 meest significant differentieel geëxprimeerde genen. Deze visualisatie werd gebruikt om te beoordelen of monsters met dezelfde experimentele conditie vergelijkbare genexpressieprofielen vertoonden.
Een volcano plot werd gebruikt om de relatie tussen de omvang van de expressieverandering (log2FC) en de statistische significantie (-log10 adjusted p-value) van de onderzochte genen weer te geven.
### Gene Ontology-analyse
Om te onderzoeken welke biologische processen geassocieerd waren met de differentieel geëxprimeerde genen werd een [Gene Ontology (GO) enrichmentanalyse](scripts/GO_analyse) uitgevoerd. Hierbij werd specifiek gekeken naar de GO-categorie Biological Process (BP). De analyse werd uitgevoerd met clusterProfiler [[12]](bronnen/Literatuurlijst_RA.pdf), waarbij de geselecteerde differentieel geëxprimeerde genen als input werden gebruikt.
De verrijking werd beoordeeld op basis van de adjusted p-value. De belangrijkste verrijkte GO-termen werden vervolgens gevisualiseerd met een dotplot. De gebruikte parameters, packageversies en scripts zijn terug te vinden in de bijbehorende analysebestanden.
### KEGG pathway enrichmentanalyse
Naast GO werd een [KEGG pathway enrichmentanalyse](scripts/KEGG) uitgevoerd om te bepalen welke biologische signaalroutes oververtegenwoordigd waren onder de differentieel geëxprimeerde genen. De analyse werd uitgevoerd met clusterProfiler [[12]](bronnen/Literatuurlijst_RA.pdf). De verrijkte pathways werden beoordeeld op basis van de adjusted p-value en weergegeven met een dotplot.
De pathways die relevant waren voor de onderzoeksvraag werden geselecteerd voor verdere visualisatie met Pathview.
## Pathwayvisualisatie met Pathview
Om de locatie van differentieel geëxprimeerde genen binnen specifieke biologische pathways te visualiseren werd het R-pakket Pathview [[10]](bronnen/Literatuurlijst_RA.pdf) gebruikt. De volgende KEGG pathways werden gevisualiseerd:
- Rheumatoid arthritis — hsa05323
- IL-17 signaling pathway — hsa04657
- TNF signaling pathway — hsa04668
  
De kleur van de genen in de Pathviewvisualisaties geeft de richting van de expressieverandering weer, waarbij rood staat voor verhoogde expressie en groen voor verlaagde expressie in de RA-groep ten opzichte van de gezonde controles.
De gebruikte scripts en outputbestanden van de GO-, KEGG- en Pathviewanalyses zijn afzonderlijk beschikbaar in de map [scripts](scripts/) en [resultaten](resultaten/).

---
<a id="workflow"></a>
## Workflow

![flowchart](assets/FlowchartRA.png)

*Figuur 1: Overzicht van de uitgevoerde transcriptomische analyseworkflow.*

---
<a id="resultaten"></a>
## Resultaten
PCA-analyse

![PCA-analyse](resultaten/PCAplot.png)

*Figuur 2:  Principal Component Analysis (PCA) van RNA-sequencingmonsters van vier gezonde controles en vier patiënten met Reumatoïde Artritis. De positie van ieder punt vertegenwoordigt het globale genexpressieprofiel van één monster. PC1 en PC2 zijn 74% en 10% van de totale variantie*

De PCA werd uitgevoerd om te beoordelen of de monsters op basis van hun globale genexpressieprofiel van elkaar verschilden en of de RA- en controlegroepen afzonderlijk clusteren.
De PCA liet een duidelijke scheiding zien tussen de gezonde controles en RA-patiënten. PC1 verklaarde 74% van de totale variantie en PC2 verklaarde 10%, waardoor de eerste twee componenten gezamenlijk ongeveer 84% van de variantie verklaarden. De monsters van de gezonde controles en RA-patiënten vormden afzonderlijke clusters. Dit wijst erop dat de twee onderzoeksgroepen duidelijke verschillen vertonen in hun globale transcriptomische profiel.


---
## Differentiële genexpressie
De [DESeq2-analyse](scripts/DESeq2) identificeerde in totaal 4572 significant differentieel geëxprimeerde genen zoals zichtbaar is in de verkregen [DESeq2 resultaten](resultaten/DESeq2). Een samenvatting van deze resultaten is zichtbaar in tabel 1.
  
*Tabel 1: samenvatting DESeq2-resultaten*
| Resultaat | Aantal |
|------------|--------:|
| Totaal geanalyseerde genen | 29407 |
| Significant differentieel geëxprimeerde genen | 4572 |
| Upregulated genen | 2085 |
| Downregulated genen | 2487 |

De analyse toont aan dat een groot aantal genen significant verschillend tot expressie komt tussen gezonde individuen en RA-patiënten. Dit bevestigt dat Reumatoïde Artritis gepaard gaat met aanwezige veranderingen in genexpressie, deze expressie wordt zowel verhoogd (upregulated) of verlaagd (downregulated). De belangrijkste up- en downregulated genen zijn zichtbaar in figuur 2 en 3

*Tabel 2: Belangrijkste upregulated genes en hun functie*
| Gen | log2 Fold Change | functie |
|------|------:|------|
| BCL2A1 | 6.71 | Regulatie van apoptose en ontstekingsreacties |
| PTGFR | 3.59 | Prostaglandine receptor |
| CYTIP | 3.43 | Activatie van immuuncellen |
| ADAMTS6 | 3.32 | Matrix remodeling |
| SRGN | 3.26 | Secretie van ontstekingsmediatoren |
| IGHV4-4 | >3 | Immunoglobuline zware keten |
| IGHV3-53 | >3 | Antigeenherkenning |
| IGKJ2 | >3 | B-cel receptor |
| IGLV1-47 | >3 | Antilichaamvorming |
| Overige IG-genen | >3 | Adaptieve immuniteit |

Verschillende immunoglobulinegenen werden sterk verhoogd gevonden, waaronder IGHV4-4, IGHV3-53, IGKJ2 en IGLV1-47. Dit suggereert verhoogde B-celactiviteit en antilichaamproductie, wat kenmerkend is voor auto-immuunziekten zoals RA.

*Tabel 3: Belangrijkste downregulated genes en hun functie*
| Gen | log2 Fold Change | Mogelijke functie |
|------|------:|------|
| ANKRD30BL | -10.12 | Transcriptieregulatie |
| MT-ND6 | -11.42 | Mitochondriale ademhaling |
| RAB3IL1 | -6.08 | Intracellulair transport |
| SLC9A3R2 | -5.62 | Iontransport |
| ZNF598 | -4.44 | Regulatie van translatie |
| Overige significante genen | < -4 | Diverse cellulaire processen |
---
Ook is er een [volcano plot](scripts/Volcanoplot) gemaakt voor het uitzetten van de significantie en de expressie van de geanalyseerde genen, dit plot toont een duidelijke verdeling van significante en niet-significante genen en geven een overzicht van alle geanalyseerde genen. Genen met een verhoogde expressie in RA bevinden zich aan de rechterzijde van de grafiek, terwijl genen met een verlaagde expressie aan de linkerzijde zichtbaar zijn. 

![volcanoplot](resultaten/volcanoplot.png)

*Figuur 3: Volcano plot van differentieel geëxprimeerde genen tussen gezonde controles en patiënten met Reumatoïde Artritis. De x-as geeft de log2 Fold Change weer en de y-as de negatieve log10 van de aangepaste p-waarde.*


---
## Heatmap
De heatmap van de 50 meest significante genen liet een duidelijke clustering zien waarbij gezonde controles en RA-patiënten volledig van elkaar gescheiden werden.

![heatmap](resultaten/heatmapplot.png)

*Figuur 4: Heatmap van de 50 meest significante differentieel geëxprimeerde genen. Iedere rij vertegenwoordigt een gen en iedere kolom een monster. Rood geeft verhoogde expressie weer en blauw verlaagde expressie.*

De duidelijke clustering van gezonde controles en RA-patiënten bevestigt de aanwezigheid van consistente transcriptomische verschillen tussen beide groepen.

---
## GO Analyse
Om de biologische betekenis van de gevonden differentieel geëxprimeerde genen te onderzoeken werd een [Gene Ontology (GO) Biological Process analyse](scripts/GO_analyse) uitgevoerd. In totaal werden 323 significant verrijkte biologische processen geïdentificeerd.

De meest significant verrijkte processen waren sterk gerelateerd aan de adaptieve immuunrespons en de activatie van lymfocyten. De hoogst scorende GO-term was:
> "Adaptive immune response based on somatic recombination of immune receptors built from immunoglobulin superfamily domains" (152 genen, adjusted p-value = 7,07 × 10⁻¹²).

Daarnaast werden sterk verhoogde expressie gevonden voor:

*Tabel 4: sterkst verijkte processen biologische processen en hoeveelheid gerelateerde genen*
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

---
## KEGG Analyse

De [KEGG pathway enrichment analyse](scripts/KEGG) identificeerde meerdere ontstekingsgerelateerde pathways.
Deze analyse identificeert biologische signaalroutes waarin significant meer differentieel geëxprimeerde genen voorkomen dan op basis van toeval verwacht zou worden.
De resultaten tonen een sterke verrijking van pathways die betrokken zijn bij immuunregulatie en ontstekingsprocessen. Met name pathways gerelateerd aan Reumatoïde Artritis, TNF-signaling en IL-17-signaling hadden grote verandering in expressie. Deze signaalroutes spelen een centrale rol bij de activatie van immuuncellen, de productie van pro-inflammatoire cytokinen en het onderhouden van chronische ontstekingsreacties in gewrichtsweefsel.

![KEGG Dotplot](resultaten/dotplotkegg.png)

*figuur 5: KEGG pathway enrichment analyse weergegeven als dotplot. De grootte van de punten geeft het aantal betrokken genen weer, en de kleur de statistische significantie van de verrijking.*

De dotplot toont de meest significant verrijkte KEGG pathways. De grootte van de punten geeft het aantal betrokken genen weer, terwijl de kleur de statistische significantie van de verrijking representeert. De sterkste verrijkingen werden gevonden voor ontstekings- en immuungerelateerde pathways

---
## Pathview Analyse

De Pathview visualisaties bevestigden dat meerdere genen binnen bekende RA-gerelateerde pathways afwijkende expressie vertonen.

![Rheumatoid Arthritis Pathway](resultaten/RA.pathview.png)

*figuur 6: Pathview-visualisatie van de Rheumatoid Arthritis pathway (KEGG hsa05323). Waarbij rood gekleurde genen verhoogde expressie hadden in RA-patiënten, en groene genen verlaagde expressie.*

De figuur toont dat meerdere genen binnen de RA-pathway afwijkend gereguleerd zijn ten opzichte van gezonde controles.


---
![IL-17 Signaling Pathway](resultaten/IL17.pathview.png)

*figuur 7: Pathview-visualisatie van de IL-17 signaling pathway (KEGG hsa04657).*

De weergegeven expressieveranderingen laten verhoogde activiteit van ontstekingsgerelateerde genen binnen deze pathway zien. IL-17 speelt een belangrijke rol bij de ontwikkeling en instandhouding van chronische ontstekingsprocessen bij Reumatoïde Artritis.


---
![TNF Signaling Pathway](resultaten/TNFsignaling.pathview.png)

*figuur 8: Pathview-visualisatie van de TNF signaling pathway (KEGG hsa04668).*

Verschillende genen binnen deze pathway vertonen significante veranderingen in expressie. TNF-signaling vormt een centrale regulator van ontsteking en is een belangrijk bij de behandeling van Reumatoïde Artritis.


---
<a id="conclusie"></a>
## Conclusie

In dit onderzoek zijn transcriptomische verschillen tussen gezonde individuen en patiënten met Reumatoïde Artritis (RA) onderzocht met behulp van RNA-sequencing. De analyse identificeerde in totaal 4572 significant differentieel geëxprimeerde genen, waarvan 2085 genen verhoogd en 2487 genen verlaagd tot expressie kwamen in de RA-groep. Deze resultaten tonen aan dat RA gepaard gaat met omvangrijke veranderingen in genexpressie en bevestigen dat de ziekte een sterke moleculaire impact heeft op het immuunsysteem. De gevonden upregulated genen waren voornamelijk betrokken bij immuunactivatie, cytokinesignalering en antilichaamproductie. Daarnaast lieten de GO- en KEGG-analyses een duidelijke verrijking zien van biologische processen en pathways die verband houden met adaptieve immuniteit, B-celgemedieerde immuunresponsen, TNF-signaling en IL-17-signaling. Deze bevindingen sluiten nauw aan bij bestaande wetenschappelijke literatuur, waarin ontregeling van B-cellen, T-cellen en pro-inflammatoire cytokinen wordt beschreven als een centraal mechanisme in de pathogenese van Reumatoïde Artritis.

Hoewel de resultaten duidelijke verschillen tussen beide groepen aantonen, heeft dit onderzoek ook beperkingen. Het aantal onderzochte monsters was relatief klein, waardoor individuele variatie mogelijk invloed heeft gehad op de resultaten. Daarnaast zijn de bevindingen uitsluitend gebaseerd op bio-informatica analyses en zijn de gevonden genexpressieveranderingen niet experimenteel gevalideerd.
Toekomstig onderzoek zou zich kunnen richten op het analyseren van grotere patiëntgroepen en het valideren van de meest significante genen met technieken zoals qPCR of eiwitexpressie-analyses. Daarnaast kunnen de geïdentificeerde genen en pathways worden onderzocht als potentiële biomarkers of therapeutische aangrijpingspunten. Daarmee draagt dit onderzoek bij aan een beter begrip van de moleculaire mechanismen achter Reumatoïde Artritis en biedt het aanknopingspunten voor verdere ontwikkeling van gepersonaliseerde behandelstrategieën.

<a id="data-stewardship"></a>
## Data Stewardship

Zie: [Data Stewardship](data_stewardship/Data_Stewardship.md) 

<a id="github-beheer"></a>
## GitHub Beheer

Zie: [GitHub beheer](data_stewardship/Github_beheer.md)

<a id="referenties"></a>
## Referenties
Zie: [Literatuurlijst](bronnen/Literatuurlijst_RA.pdf)




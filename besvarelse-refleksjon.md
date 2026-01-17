# Besvarelse på refleksjonspørsmålene

Ditt brukernavn på Oslomet: 

## Refleksjonsspørsmål Oppgave 1 

S1: Hva er fordelene med å bruke JSON i stedet for CSV for API-respons?
- Ditt svar: JSON er bedre egnet for web-API fordi det er strukturert, lett å parse i JavaScript, og støtter objekter og arrays direkte
  
S2: Hvordan kan en frontend-applikasjon (nettleser) bruke denne API-en?
- Ditt svar: Den kan bruke fetch() til å sende en HTTP GET forespørsel til API og deretter hente informasjon 

S3: Hvordan ville du testet denne API-en manuelt?
- Ditt svar: Du kan bruke nettleser, curl eller Postman for å sende en HTTP forespørsel 


## Refleksjonsspørsmål Oppgave 2

### Del a):

S1: Hva er Path Traversal (Directory Traversal), og hvorfor er det farlig?
- Ditt svar: Lar angripere lese filer utenfor den tiltenkte mappen ved å bruke ../, alstå gå opp et nivå. 
- Det er farlig fordi angriper kan få tak i hemmelige data og filer 

S2: Hvordan kan du beskytte koden din mot Path Traversal?
- Ditt svar: Du kan beskytte deg ved å normalisere path, og hvis stien prøver å gå utenfor blir forespøreseln avvist (404 eller 403)


### Del b):

S1: Hva er SQL injection, og hvordan kan det oppstå i en webapplikasjon?
- Ditt svar: SQL injection oppstår når brukerdata blir satt i en webapplikasjon uten noe validering

S2: Hvordan kan du beskytte deg mot SQL injection?
- Ditt svar: Ved å validere bruker input på backend og sørge for at input behandles som data 

S3: Hva er forskjellen på validering på frontend vs backend?
- Ditt svar: Frontend validering forbedrer brukeropplevelse, men backend validering er nødvendikg for mer sikkerhet fordi man kan omgå frontend

S4: Hva er likheten mellom Path Traversal og SQL Injection?
- Ditt svar: Begge er type angrep hvor brukerinput manipuleres for å få tilgang til mer data utenfor det som er ment

  
## Refleksjonsspørsmål Oppgave 3

S1: Hva er forskjellen mellom POST og PUT?
- Ditt svar: POST brukes vanligvis for å opprette noe nytt
- PUT brukes for å oppdatere/erstatte noe som allerede finnes på en kjent plass/ID
  
S2: Hvordan sikrer du at data forblir konsistent når du oppdaterer en fil?
- Ditt svar:Jeg sikrer konsistens ved å validere input og sørge for at skriving til fil skjer atomisk eller med fil-lås, slik at fila ikke kan bli delvis skrevet eller overskrevet samtidig.

S3: Hva skjer hvis to brukere prøver å oppdatere samme student samtidig?
- Ditt svar: Hvis to brukere oppdaterer samme student samtidig, kan oppdateringer kollidere. 
- Den siste som skriver til CSV kan overskrive den første og en endring kan forsvinne uten feilmelding

## Refleksjonsspørsmål Oppgave 4 

S1: Hva er implikasjonene av å tillate DELETE-operasjoner?
- Ditt svar: Du kan miste data permament og det kan misbrukes hvis hvem som helst kan slette data 

S2: Hvordan ville du implementert "soft delete"?
- Ditt svar: I stedet for å fjerne studenten fra datastrukturen eller CSV-filen, kan man legge til et flagg som deleted=true. 
- API-et filtrerer bort slettede studenter i GET-endepunkter, mens dataene fortsatt kan brukes til statistikk og historikk.

S3: Hvordan kan du sikre at statistikk er korrekt når data endres?
- Ditt svar: Statistikk kan holdes korrekt ved å beregne den på nytt hver gang den etterspørres, basert på de oppdaterte dataene.



SLUTT.

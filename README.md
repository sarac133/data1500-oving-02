# Oppgavesett 1.2: Webapplikasjoner

## Oversikt

Oppgavesettet 1.2 består av 4 deloppgaver som introduserer webapplikasjoner, HTTP-API-er, og CRUD-operasjoner. Fokus er på å forstå separasjonen mellom frontend og backend, samt sikkerhet og ytelse i webapplikasjoner.

Nummerering "1.2" tolkes slik at den første "1" betyr første del av grunnpensum og den andre "2" betyr nummer til oppgavesettet i grunnpensum.   
   

**Estimert tid:** 8-10 timer totalt

### Oppgave 1: Enkel READ-API (ca. 1.5 timer)
- **Fokus:** HTTP GET, JSON-respons, API-design
- **Tema:** Frontend vs Backend, separasjon av bekymringer
- **Oppgave:** Utforske en webserver som tilbyr en GET-API for å hente studentdata fra CSV og returnere som JSON

### Oppgave 2: API med Søk (ca. 2 timer)
- **Fokus:** Query-parametere, input-validering, SQL injection
- **Tema:** Sikkerhet i webapplikasjoner, validering på frontend vs backend
- **Oppgave:** Lag søkefunksjonalitet med eksempel på SQL injection-sårbarhet

### Oppgave 3: CRUD-API med UPDATE (ca. 2 timer)
- **Fokus:** HTTP PUT, datamodifikasjon, datakonsistens
- **Tema:** POST vs PUT, atomare operasjoner, concurrency
- **Oppgave:** Implementer UPDATE-operasjon for å endre studentdata

### Oppgave 4: CRUD-API med DELETE og Analytics (ca. 2.5 timer)
- **Fokus:** HTTP DELETE, kompleks dataanalyse, API-design
- **Tema:** Soft delete, statistikk, aggregering
- **Oppgave:** Implementer DELETE-operasjon og analyse-endepunkt for quiz-resultater

---

## Programmeringsmiljø og Testing

### Krav
- **Java:** OpenJDK 21+ (eller annen Java-implementasjon)
- **Nettverkstilgang:** For å teste API-er lokalt
- **curl:** For å teste API-er fra kommandolinje (eller Postman/lignende)

### Valg av IDE
Du kan bruke:
- IDE (IntelliJ IDEA, Eclipse, VS Code med Java-utvidelser)
- Frittstående editor (Sublime Text, VS Code)
- Kommandolinje (javac + java)

### Testing lokalt

Denne repository inneholder skript for lokal testing. Du må sørge for at skriptene har nødvendige rettigheter.

Det anbefales å teste hver oppgave separat.

**macOS og Linux:**
```bash
$ git clone <repository_med_oppgaven>
$ cd <repository_navn>
$ chmod 755 test-local.sh
$ ./test-local.sh
```

**Windows (PowerShell):**
```powershell
> Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
> .\test-local.ps1
```

**Windows (Command Prompt):**
```cmd
> test-local.bat
```

### GitHub Actions Autograding

Hver gang du gjør en `git push`, kjøres tester automatisk i GitHub Actions. Se resultatene under "Actions"-fanen i repository.

---

## Deloppgaver

### Oppgave 1: Enkel READ-API

**Mål:** Forstå HTTP GET, JSON-serialisering, og API-design

**Oppgave:**

1. Lag en Java-klasse `StudentAPI.java` som implementerer en enkel webserver
2. Implementer følgende endepunkter:
   - `GET /api/students` - Hent alle studenter
   - `GET /api/students/{id}` - Hent student med spesifikk ID
   - `GET /health` - Sjekk server-status

3. Serveren skal:
   - Lese studentdata fra `studenter.csv`
   - Returnere JSON-format
   - Kjøre på port som spesifiseres som argument

**Bruk:**
```bash
java StudentAPI 8000 studenter.csv
```

**Test:**
```bash
curl http://localhost:8000/api/students
curl http://localhost:8000/api/students/101
curl http://localhost:8000/health
```

**Forventet output:**
```json
[
  {"id":101,"name":"Mickey","program":"CS"},
  {"id":102,"name":"Daffy","program":"EE"},
  ...
]
```

#### Refleksjonsspørsmål:
- S1: Hva er fordelene med å bruke JSON i stedet for CSV for API-respons?
- S2: Hvordan kan en frontend-applikasjon (nettleser) bruke denne API-en?
- S3: Hvordan ville du testet denne API-en manuelt?

---

### Oppgave 2: API med Søk og SQL Injection

**Mål:** Forstå søkefunksjonalitet, input-validering, og sikkerhet

**Oppgave:**

1. Lag en Java-klasse `UserSearchAPI.java` som implementerer søkefunksjonalitet
2. Implementer følgende endepunkter:
   - `GET /api/users` - Hent alle brukere
   - `GET /api/search?email=...` - Søk etter bruker (SÅRBAR versjon)
   - `GET /api/search-safe?email=...` - Søk etter bruker (SIKKER versjon)

3. Den sårbare versjonen skal:
   - Ikke validere inndata
   - Være sårbar for SQL injection-prinsippet
   - Illustrere problemet med dårlig input-håndtering

4. Den sikre versjonen skal:
   - Validere e-postformat
   - Avvise inndata med farlige tegn
   - Gjøre eksakt søk

**Bruk:**
```bash
java UserSearchAPI 8001 brukere.csv
```

**Test:**
```bash
curl "http://localhost:8001/api/search?email=bruker1@epost.no"
curl "http://localhost:8001/api/search-safe?email=bruker1@epost.no"
```

#### Refleksjonsspørsmål:
- S1: Hva er SQL injection, og hvordan kan det oppstå i en webapplikasjon?
- S2: Hvordan kan du beskytte deg mot SQL injection?
- S3: Hva er forskjellen på validering på frontend vs backend?

---

### Oppgave 3: CRUD-API med UPDATE

**Mål:** Forstå CRUD-operasjoner, HTTP-metoder, og datakonsistens

**Oppgave:**

1. Lag en Java-klasse `StudentCRUDAPI.java` som implementerer CRUD-operasjoner
2. Implementer følgende endepunkter:
   - `GET /api/students` - Hent alle studenter
   - `GET /api/students/{id}` - Hent student
   - `POST /api/students` - Opprett ny student
   - `PUT /api/students/{id}` - Oppdater student
   - `DELETE /api/students/{id}` - Slett student

3. Serveren skal:
   - Validere inndata (navn og program ikke tomme)
   - Lagre endringer til CSV-fil
   - Håndtere feil (student ikke funnet, ugyldig data)

**Bruk:**
```bash
java StudentCRUDAPI 8002 studenter.csv
```

**Test:**
```bash
# GET
curl http://localhost:8002/api/students/101

# PUT
curl -X PUT -H "Content-Type: application/json" \
     -d '{"name":"Mickey Mouse","program":"CS"}' \
     http://localhost:8002/api/students/101

# POST
curl -X POST -H "Content-Type: application/json" \
     -d '{"name":"NewStudent","program":"EE"}' \
     http://localhost:8002/api/students
```

#### Refleksjonsspørsmål:
- S1: Hva er forskjellen mellom POST og PUT?
- S2: Hvordan sikrer du at data forblir konsistent når du oppdaterer en fil?
- S3: Hva skjer hvis to brukere prøver å oppdatere samme student samtidig?

---

### Oppgave 4: CRUD-API med DELETE og Analytics

**Mål:** Forstå DELETE-operasjoner, dataanalyse, og statistikk

**Oppgave:**

1. Lag en Java-klasse `QuizAnalyticsAPI.java` som implementerer DELETE og analyse
2. Implementer følgende endepunkter:
   - `GET /api/students` - Hent alle studenter
   - `GET /api/students/{id}` - Hent student
   - `DELETE /api/students/{id}` - Slett student
   - `GET /api/analytics/quiz-stats` - Hent quiz-statistikk
   - `GET /api/analytics/student-stats/{id}` - Hent student-statistikk

3. Quiz-statistikk skal beregne:
   - Gjennomsnittlig score per quiz
   - Standardavvik
   - Min og max score
   - Antall deltakere

4. Student-statistikk skal beregne:
   - Gjennomsnittlig prosentpoeng
   - Antall quizer tatt

**Bruk:**
```bash
java QuizAnalyticsAPI 8003 studenter.csv quiz-res.csv
```

**Test:**
```bash
curl http://localhost:8003/api/analytics/quiz-stats
curl http://localhost:8003/api/analytics/student-stats/101
curl -X DELETE http://localhost:8003/api/students/101
```

#### Refleksjonsspørsmål:
- S1: Hva er implikasjonene av å tillate DELETE-operasjoner?
- S2: Hvordan ville du implementert "soft delete"?
- S3: Hvordan kan du sikre at statistikk er korrekt når data endres?

---

## Testdata

Testdata finnes i `testdata/data/`:

- `studenter.csv` - Studentdata
- `brukere.csv` - Brukerdata
- `quiz-res.csv` - Quiz-resultater

### Format

**studenter.csv:**
```
101,Mickey,CS
102,Daffy,EE
103,Donald,CS
104,Minnie,PSY
105,Goofy,EE
```

**brukere.csv:**
```
1,bruker1@epost.no,Navn Navnesen 1
2,bruker2@epost.no,Navn Navnesen 2
...
```

**quiz-res.csv:**
```
quiz_id,student_id,score,max_score
1,101,85,100
1,102,92,100
...
```

---

## Refleksjonsspørsmål

Alle refleksjonsspørsmål skal besvares i `besvarelse-refleksjon.md`. Dette dokumentet inneholder:
- Spørsmål for hver oppgave
- Plass for dine svar
- Referanseinformasjon og eksempler

---

## Innlevering

1. Gjør alle oppgavene
2. Besvare alle refleksjonsspørsmål i `besvarelse-refleksjon.md`
3. Test lokalt med `test-local.sh` (macOS/Linux) eller `test-local.ps1` (Windows)
4. Gjør `git add`, `git commit`, og `git push`
5. Sjekk GitHub Actions for autograding-resultater

---

## Ressurser

- [HTTP-spesifikasjon](https://tools.ietf.org/html/rfc7231)
- [JSON-format](https://www.json.org/)
- [REST-prinsipper](https://restfulapi.net/)
- [OWASP Top 10 - SQL Injection](https://owasp.org/www-community/attacks/SQL_Injection)
- [Java HttpServer dokumentasjon](https://docs.oracle.com/en/java/javase/21/docs/api/com.sun.net.httpserver/module-summary.html)

---

## Lisens

CC0-1.0 (Public Domain)

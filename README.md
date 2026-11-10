# CBDVentures — Pretoria CBD in Your Pocket

CBDVentures is a mobile-first guide and local discovery platform for students, residents and visitors in Pretoria Central. It brings together place discovery, a student-focused assistant, maps, events and tools for local business owners.

**Live demo:** [cbdventures-final-project.onrender.com](https://cbdventures-final-project.onrender.com)  
**Project:** IT Project Group 5  
**Campus reference:** Richfield Graduate Institute of Technology, 291 Helen Joseph Street, Pretoria Central

## What the app includes

| Screen or area | What it does |
|---|---|
| Discover | Presents categories, featured places, recommendations and upcoming events from the platform catalogue. |
| Explore | Searches the selected student places described below. |
| Ask (Assistant) | Answers questions about those same student places, offers simple student-budget suggestions and opens walking directions from Richfield. |
| Map | Shows active listings from the wider platform catalogue on an interactive map. |
| Business profiles and reviews | Show listing details, average ratings, review counts and the 1–5 star distribution from submitted reviews. |
| Events | Shows upcoming events and lets users save events in the current browser. |
| Accounts and profiles | Supports guest browsing, registration, email verification, sign-in and optional Google or Apple sign-in. |
| Owner tools | Let business owners manage their listings and venue events. |
| Admin tools | Provide listing verification, reports, CSV export, and database backup and restore. |

## Explore and Assistant: one shared place list

Explore and Ask use the **same curated directory of 13 places**. These are the only student-directory places shown across both screens. The directory is stored in `src/main/resources/assistant/places.json` and is served through the public Assistant API. Explore reads that API too, so the two screens stay aligned.

| Place | Category | Address or location supplied |
|---|---|---|
| Xpresso Coffee Shop | Food & coffee | Pretoria Central; exact street address was not supplied |
| Honchos | Food & coffee | 225 Pretorius Street, Pretoria Central |
| Family Chips | Food & coffee | 207 Pretorius Street, Pretoria Central |
| Magwinya Zone | Food & coffee | Middestad Mall, 752R+Q9Q |
| Thuba Rush KJ | Food & coffee | Opera Plaza, 230 Pretorius Street |
| ABSA Building | Banks & ATMs | 224/230 Lilian Ngoyi Street; exact entrance is unverified |
| Asian Delight Shawarma | Food & coffee | 223 Central Street |
| Quick Bake Confectioners & Coffee | Food & coffee | 7 Bank Lane |
| Phola Shisa Nyama | Food & coffee | 219 Pretorius Street |
| Four Four Two Sports & Music Lounge | Entertainment | Pretoria Central |
| Top Class Fast Foods | Food & coffee | 287 Pretorius Street |
| The South African State Theatre | Entertainment | 320 Pretorius Street, Pretoria Central, Pretoria, 0001 · 012 392 4000 · [website](http://www.statetheatre.co.za/) |
| Container 4 E&T Beauty Salon | Beauty & grooming | 344 Francis Baard Street, Pretoria Central, Pretoria, 0002 · [map reference](https://maps.app.goo.gl/JBbRyR2r7D5DDToC9) |

Ten places have standalone supplied photos in `src/main/resources/static/images/places/`. The Xpresso, State Theatre and beauty salon photos were only available inside chat screenshots, so those cards currently use category icons. Map pins and addresses come from the supplied location references. The State Theatre has a supplied map pin; the beauty salon's location was supplied as an address and map link without coordinates, so it is marked as unverified and is not given a calculated distance. Confirm a venue's current entrance, hours, services and prices before making a special trip.

This curated student list is separate from the wider database catalogue used by Discover, Map and the business-management features. Seeded demo businesses in that catalogue do not get added to Explore or Ask.

### Assistant behavior

The guide uses local rules and the curated directory; it does not require a paid AI API key. It can match place names and aliases, answer supported questions about the listed places, show place cards and link to walking directions from Richfield. It does not have confirmed menus or opening hours for every place, so it should not guess those details. Budget amounts are suggestions, not confirmed venue prices.

## Technology

- Java 25 and Spring Boot 4.1.2
- Spring Web MVC, Spring Data JPA, Spring Security and Bean Validation
- H2 database for the local demo; MySQL 8 through the `mysql` profile
- HTML, CSS and vanilla JavaScript for the web client
- Leaflet and OpenStreetMap for the interactive map
- Maven Wrapper and Docker
- Render for the hosted demo

The frontend is served by the Spring Boot application. No Node.js installation or separate frontend build step is required.

## Run locally

### Requirements

- JDK 25
- Git
- Internet access for the first Maven dependency download

### Start the app

Clone the repository, open a terminal in its root folder and run:

```bash
git clone https://github.com/XitshembisoNgwenya/cbdventures-final-project.git
cd cbdventures-final-project
./mvnw spring-boot:run
```

On Windows, use:

```bat
mvnw.cmd spring-boot:run
```

Open [http://localhost:8080](http://localhost:8080). The default profile uses an H2 file database in `./data`; the first start seeds demo catalogue data. Stop the app before deleting `data/` to reset the local demo database.

To build a runnable JAR:

```bash
./mvnw clean package
java -jar target/cbdventures-0.0.1-SNAPSHOT.jar
```

To run the automated checks:

```bash
./mvnw test
```

## Database configuration

### H2 demo database

H2 runs locally without a separate database server and stores its data in `./data/cbdventures.mv.db`. This is convenient for demonstrations and local development.

### MySQL 8 profile

Apply the supplied schema to a MySQL database, then set the connection variables and activate the profile:

```bash
mysql -u <database-user> -p < db/schema_mysql.sql
export DB_HOST=localhost
export DB_PORT=3306
export DB_NAME=cbdventures
export DB_USER=<database-user>
export DB_PASSWORD=<database-password>
./mvnw spring-boot:run -Dspring-boot.run.profiles=mysql
```

Set `CBD_SEED=false` if startup seeding should be disabled. Use secure, unique credentials for any shared deployment.

## Environment variables

| Variable | Purpose |
|---|---|
| `PORT` | Web server port; defaults to `8080`. Render supplies this for its web service. |
| `CBD_JWT_SECRET` | Secret used to sign authentication tokens. Set a unique value of at least 32 characters outside local development. |
| `GOOGLE_CLIENT_ID` / `GOOGLE_CLIENT_SECRET` | Optional Google sign-in credentials. |
| `APPLE_CLIENT_ID` / `APPLE_CLIENT_SECRET` | Optional Apple sign-in credentials. |
| `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD` | MySQL connection settings for the `mysql` profile. |
| `CBD_SEED` | Set to `false` to disable seeding when using the MySQL profile. |

Add secrets through the deployment provider's environment settings. Do not commit real credentials or signing keys.

## Deploying on Render

The repository includes a Dockerfile for the Render Web Service. Connect the repository, choose the Docker runtime and deploy the `main` branch. Configure `CBD_JWT_SECRET` and any OAuth or MySQL variables in the service's Environment settings.

The default H2 database is file-backed. For data that must persist across service restarts or redeploys, configure persistent storage or use a managed MySQL database.

## API overview

All API routes are under `/api`. See [docs/api.md](docs/api.md) for endpoint details and request/response examples.

| Endpoint | Purpose |
|---|---|
| `GET /api/assistant/config` | Assistant categories and campus reference information. |
| `GET /api/assistant/places` | Shared curated directory used by Explore and Ask; supports search and category filters. |
| `GET /api/assistant/places/{id}` | One curated place record. |
| `POST /api/assistant/chat` | Sends a conversation to the local guide. |
| `GET /api/discover/home` | Data for the Discover screen. |
| `GET /api/businesses` and `GET /api/businesses/map` | Search and map data for the wider platform catalogue. |
| `GET /api/events` | Upcoming events. |
| `/api/auth/*` | Registration, verification, login, password and OAuth routes. |
| `/api/owner/*` | Business-owner listing and event management. |
| `/api/admin/*` | Listing review, reports, export and backup administration. |

## Demo data and accounts

With demo seeding enabled, the local database is populated with sample businesses, events and role-based accounts for demonstration. Create a visitor account from the app, and use project-approved demo access when presenting owner or administrator features. Do not publish demo passwords or reuse them on a public deployment. Passwords are stored as BCrypt hashes.

## Project structure

```text
db/                                      MySQL schema, triggers and database checks
docs/                                    API reference and project documentation
src/main/java/za/ac/richfield/cbdventures/
  assistant/                             Shared directory and chatbot API/service
  config/                                App settings, seeding and security configuration
  domain/                                Database entities and enums
  repo/                                  Spring Data repositories
  security/                              JWT, OAuth and current-user support
  service/                               Business rules and platform services
  web/                                   REST controllers and response DTOs
src/main/resources/
  assistant/places.json                  Shared Explore and Assistant directory
  application.yml                        Local H2 defaults
  application-mysql.yml                  MySQL profile
  static/                                Web client, styles, scripts and assets
src/test/java/                           Automated test suite
Dockerfile                               Render container build
mvnw                                     Maven Wrapper
pom.xml                                  Dependencies and Java version
```

## Scope and known limitations

- The Assistant is a rule-based student guide, not a general-purpose AI chatbot.
- Some student-supplied places do not have confirmed coordinates, full addresses, current menus or opening hours.
- Feedback after opening directions is stored in the user's browser; it does not automatically alter a shared place record.
- Payment processing and reservations are outside the current build.
- The curated directory and the platform's business catalogue are separate data sources.


## Database testing evidence

A redacted database testing report and SQL exports are archived in [docs/database-evidence/2026-11-10/](docs/database-evidence/2026-11-10/README.md). They document a separate MySQL test schema and do not replace `db/schema_mysql.sql` or connect the running app to that database. The SQL exports contain `DROP TABLE` statements and should only be restored into disposable test schemas.

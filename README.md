# SmartSahay API (Module 2: Backend API and Controller Layer)

Backend for **SmartSahay**, a Digital Farmer Assistance System that helps farmers find government agricultural schemes they may be eligible for.

Minor Project-I (22UCSL505), Department of Computer Science and Engineering, SDM College of Engineering and Technology, Dharwad. Academic year 2026-27. Guide: Prof. Chaitali Chate.

## What it does

- Lists and filters 17 central and Karnataka agricultural schemes.
- Shows full scheme details: benefits, eligibility, required documents and application steps.
- Checks eligibility from a farmer's details (land, income, age, state, category, crop) and explains why a scheme does not match.
- Serves scheme names and descriptions in English, Hindi and Kannada (partial, see Known limitations).
- Admin API to add, edit and hide schemes, protected by a login token.

## Tech stack

| Layer | Technology |
|---|---|
| Language | Java 21 |
| Web | Jakarta Servlets 6 on Apache Tomcat 10.1 |
| Build | Maven (WAR packaging) |
| Database | MySQL 8.0 with JDBC (mysql-connector-j 8.4) |
| JSON | Gson 2.10 |
| Testing | Postman |

## Project structure

```
smartsahay-api/
├── db/                              SQL scripts, run in order
│   ├── 03_translations.sql
│   ├── 02_seed.sql
│   └── 03_translations.sql
├── postman/                         Postman test collection
├── src/main/java/com/smartsahay/
│   ├── dao/        SchemeDAO, SchemeAdminDAO, RuleDAO     (all SQL lives here)
│   ├── filter/     CorsFilter
│   ├── model/      Scheme, SchemeRule, SchemeInput, EligibilityRequest, EligibilityResult
│   ├── service/    EligibilityService, AuthService
│   ├── servlet/    HealthServlet, SchemeServlet, EligibilityServlet,
│   │               AdminLoginServlet, AdminSessionServlet
│   └── util/       DBConnection, JsonUtil, AuthGuard
├── src/main/resources/
│   ├── app.properties               CORS allowed origins
│   └── db.properties.example        copy to db.properties (never committed)
├── src/main/webapp/index.html
└── pom.xml
```

## Setup

### Prerequisites

- JDK 21
- MySQL 8.0 and MySQL Workbench
- Apache Tomcat 10.1.x (it must be 10 or newer, because the code uses the `jakarta.*` packages)
- IntelliJ IDEA with the Smart Tomcat plugin (or any way to deploy a WAR to Tomcat)

### 1. Create the database

In MySQL Workbench, open a connection to your local server and run these scripts **in this order**:

1. `db/01_schema.sql` creates the `smartsahay` database and 6 tables.
2. `db/02_seed.sql` loads the 17 schemes. Its last query should show 17 schemes and 17 rules.
3. `db/03_translations.sql` adds `last_verified`, the `active` flag and the `scheme_translations` table with draft Hindi and Kannada text.

Run the three scripts once on a fresh database. To start over, run `DROP DATABASE smartsahay;` and repeat all three. (Re-running `02` alone deletes the translations, and re-running `03` fails because its columns already exist.)

### 2. Configure

1. Copy `src/main/resources/db.properties.example` to `src/main/resources/db.properties` (this file is gitignored).
2. Fill in your MySQL password and choose an admin password:

```properties
db.url=jdbc:mysql://localhost:3306/smartsahay?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
db.user=root
db.password=YOUR_MYSQL_PASSWORD
admin.username=admin
admin.password=CHOOSE_A_STRONG_PASSWORD
```

3. In `src/main/resources/app.properties`, list the addresses your frontend runs on (comma separated). Browsers can only call the API from these origins:

```properties
cors.allowed.origins=http://127.0.0.1:5500,http://localhost:5500,http://localhost:3000,http://localhost:8080
```

**Never commit `db.properties`.** It holds passwords.

### 3. Run

**With IntelliJ and Smart Tomcat**

1. Run, then Edit Configurations, then add a **Smart Tomcat** configuration.
2. Tomcat server: your Tomcat 10.1 folder.
3. Deployment directory: `src/main/webapp`.
4. Use classpath of module: `smartsahay-api`.
5. Context path: `/smartsahay`. Server port: `8080`.
6. Press Run.

**Or with a WAR file**

```
mvn clean package
```

Copy `target/smartsahay.war` into Tomcat's `webapps` folder and start Tomcat.

### 4. Check it works

Open `http://localhost:8080/smartsahay/api/health`. You should see:

```json
{"status":"UP","service":"SmartSahay API","database":"UP","schemesCount":17}
```

## API overview

Base URL: `http://localhost:8080/smartsahay`. All requests and responses are JSON (UTF-8). Errors always look like `{"error":"message"}`.

| Method | Path | Login | Purpose |
|---|---|---|---|
| GET | `/api/health` | no | API and database status |
| GET | `/api/schemes` | no | List schemes. Filters: `category`, `state`, `level`, `lang` (en, kn, hi) |
| GET | `/api/schemes/{slug}` | no | One scheme with benefits, eligibility, documents, steps |
| POST | `/api/eligibility` | no | Eligible and not-eligible schemes, with reasons |
| POST | `/api/admin/login` | no | Get an admin token (valid 2 hours) |
| GET | `/api/admin/session` | yes | Check the token is still valid |
| POST | `/api/schemes` | yes | Create a scheme |
| PUT | `/api/schemes/{slug}` | yes | Update a scheme |
| DELETE | `/api/schemes/{slug}` | yes | Hide a scheme (soft delete) |

Admin requests send `Authorization: Bearer <token>`. The full contract, with request and response examples for every endpoint, is in the team's API Contract document.

### Eligibility request example

```json
{"landAcres":3.7,"annualIncome":400000,"age":35,"state":"Karnataka","category":"SC","crop":"MILLET"}
```

`category` is one of `GENERAL`, `SC`, `ST`, `OBC`, `MINORITY`. Send land as `landHectares` or `landAcres`. Nothing about the farmer is stored.

## Design notes

- **Layers:** servlet, then service or DAO. Servlets never contain SQL, and `EligibilityService` has no web or database code, so the IVR module can reuse it.
- **Eligibility rules are data.** Each scheme has one row in `scheme_rules` (land range, income limit, age range, Karnataka only, allowed categories and crops). A NULL rule means no restriction, and every rule that is set must pass.
- **Safe database access:** prepared statements everywhere, and transactions for admin writes so a scheme is saved completely or not at all.
- **Soft delete:** deleting hides a scheme (`active = FALSE`) instead of destroying it.
- **Admin auth:** a random token kept in server memory, checked by `AuthGuard` at the top of each protected servlet.
- **CORS:** an allowlist of origins, not a wildcard.

## Testing

Import `postman/SmartSahay_Step4_Tests.postman_collection.json` into Postman and run the collection. With exactly 17 active schemes, all 37 tests should pass.

## Known limitations

- Hindi and Kannada text exists for 3 of 17 schemes, and only for name and description. The rest fall back to English.
- Scheme data comes from one source document and is not yet verified against official portals. `last_verified` is empty until it is.
- Yes/no criteria such as needing a FRUITS ID or being a tenant farmer are not part of the matching rules.
- Single admin account, no login attempt limit, no logout endpoint, and tokens are lost when the server restarts.
- No endpoint to restore a hidden scheme yet.
- One database connection per request (no connection pool). Development runs on plain HTTP; a real deployment needs HTTPS.
- Eligibility results are indicative only, not an official decision.

## Team

| Module | Owner |
|---|---|
| 1. Frontend and accessibility layer | Naveen G Allayyanavaramath |
| 2. Backend API and controller layer (this repository) | Shreyas Hiremath |
| 3. Database and logic engine | Tanishq Suryavanshi |
| 4. IVR integration and admin subsystem | Pratik Desai |

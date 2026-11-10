# Database testing evidence - public redacted copies

This folder contains public copies of the database-testing materials provided on 10 November 2026. The SQL schemas and test evidence are preserved, with personal and account data removed.

## Relationship to the CBDVentures app

The report describes MySQL Workbench tests on cbdventures_db_test and a restore into cbdventures_db_restore. The exports use a separate schema with plural table names such as users, businesses and reviews.

The Spring Boot application's MySQL schema remains in db/schema_mysql.sql. It uses a different database model and is not replaced by these exports. These files are archival evidence; the app does not load them, and the report explicitly says it does not establish an application-to-database connection.

## Public redactions

- User names and email addresses are replaced with synthetic example.invalid addresses.
- Password hash values are replaced with non-login placeholders.
- Business phone and email fields are cleared.
- User activity and preference rows are omitted.
- The PDF's local export log is redacted from its screenshot; the export-completed status and reported counts remain visible.

The unredacted SQL exports should not be published in this public repository.

## Files

| File | Purpose |
|---|---|
| CBDventures_Database_Testing_Report_public_redacted.pdf | Five-page report. It records 12 base tables, one view, five users, 13 businesses, four reviews and two events in the tested schema, plus five rejected invalid-data operations and a separate restore check. |
| Database_backup_public_redacted.sql | Redacted copy of the backup used in the report for cbdventures_db_test. |
| CBDventures_Database_Dump_public_redacted.sql | Redacted development snapshot for cbdventures_db, with 13 business rows. |
| cbdventures_full_dump_public_redacted.sql | Later redacted development snapshot for cbdventures_db, with 15 business rows. It is a different snapshot from the tested 13-business backup. |

## Restore caution

The SQL exports contain destructive DROP TABLE statements. Review them before use and restore only into a disposable test schema. They are not migrations or a production backup of the Spring Boot application's database.

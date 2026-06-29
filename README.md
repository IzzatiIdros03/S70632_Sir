# S70632 Masjid Management System

## Running (NetBeans / Tomcat)

1. Open the project folder in NetBeans.
2. Put required JARs into `web/WEB-INF/lib`:
   - `mysql-connector-j-9.2.0.jar`
   - `taglibs-standard-impl-1.2.5.jar`
   - `taglibs-standard-jstlel-1.2.5.jar`
   - `taglibs-standard-spec-1.2.5.jar`
2. Configure your MySQL database and update `src/java/util/DBConnection.java` if needed.
3. Run the project on Tomcat.

## ToyyibPay configuration

This project supports configuring ToyyibPay via either:

1) Environment variables (recommended), or
2) A local properties file at `web/WEB-INF/toyyibpay.properties` (not committed to Git)

Priority order: Environment variables > `toyyibpay.properties` > defaults.

### Environment variables

- `TOYYIBPAY_SECRET_KEY`
- `TOYYIBPAY_CAT_BOOKING`
- `TOYYIBPAY_CAT_DONATION`
- `TOYYIBPAY_BASE_URL` (default `https://toyyibpay.com/`)
- `MMS_PUBLIC_BASE_URL` (your public base URL, e.g. current ngrok URL)

Note: Avoid committing real payment secrets to GitHub (prefer a private repo, and/or store secrets outside source code).

### Properties file

Copy `web/WEB-INF/toyyibpay.properties.example` to `web/WEB-INF/toyyibpay.properties` and fill in values.

# Keycloak 7.0 setup for OpenRMF Login and RBAC
OpenRMF uses Keycloak (OpenID) initially for login and password access as well as role based access control. You also can use Keycloak for linking to Identity Providers with Google, GitHub, Twitter, and others for access to OpenRMF. Feel free to follow these Keycloak directions or use another provider that can give you OpenID functionality. The Keycloak setup is below and should be similar to other OpenID applications. This setup below uses Keycloak 7.0. I have not tried it on version 6 or below. If you must use 6 then you will need to test to ensure it works 100%.

## Running Keycloak in Docker
You can use the below line to run Keycloak and use Postgres to save the configuration information. Please update your passwords appropriately in the [docker-compose.yml](scripts/keycloak/docker-compose.yml) file. We have a docker-compose file you can readily pull down and use in our scripts/keycloak directory for you to make this easy.

Mac/Linux:
```
./scripts/keycloak/start.sh
```

Windows:
```
./scripts/keycloak/start.cmd
```

To stop this, run the "stop" script for the Mac/Linux (.sh) or Windows (.cmd) command you started.

## Automated Script for Setting up Keycloak
We had a contributor (KC) setup an automated way to define your realm in Keycloak with a script thankfully!  Make sure you `chmod +x` on one of the files linked below for your OS. Run the script and it asks you for the IP of the computer, the first user to make, and then connects to the jboss/keycloak container running. It adds the openrmf realm, client, password policy, roles, first administrator, as well as the default role for users to register.

> Note: You MUST have Keycloak running locally in Docker on the machine where this is run for it to work as-is.

* Mac Users can use [setup-realm-mac.sh](scripts/keycloak/setup-realm-mac.sh) file.
* Linux users can use the [setup-realm-linux.sh](scripts/keycloak/setup-realm-linux.sh) file. 
* Windows users, stay tuned!

## Step by Step Manual Directions

1. Log in to your Keycloak instance, whether online or within containers (docker, kubernetes) or natively on your machine
2. Create a new Realm for openrmf
3. In General update the Display Name and make sure Enabled is turn to ON
4. Click Save
5. Go to Login and set User Registration to ON if you wish
6. Set Require SSL appropriately (i.e. none for development locally only)
7. Set any other options you wish and click Save
8. Click on Authentication in the left menu
9. Click the Password Policy tab and set all appropriate policies (digits, special characters, upper and lower case, expiration, etc.)
10. Click Save to set all password policies

### Password Policy Screenshot
![Image](./img/keycloak/authentication-password-policy.png?raw=true)

11. Click Roles on the far left menu
12. Add the following roles: Administrator, Assessor, Download, Editor, Reader (use proper case)
13. Go to the Default Roles tab and add the Reader role, so new users can at least get Reader (if you wish)
14. Click on Clients on the far left menu
15. Click the Create Button to make a new client
16. Name it `openrmf` and make sure openid-connect is the client protocol
17. Click the Save button
18. Add the Name and Description fields
19. Set the access type to public
20. Disable the Direct Access Grants
21. Setup the Valid Redirect URIs to where your OpenRMF main root URL is (i.e. http://{ip-address}:8080/*)
22. Set the Web Origins appropriately for CORS (i.e. development could be * or your specific URL)
23. Click the Save button to save this initial setup

### Client Settings Screenshot
![Image](./img/keycloak/keycloak-openrmf-settings.png?raw=true)

24. Click on the Client Scopes tab to ensure the `roles` scope is in the right hand box to pass to OpenRMF upon login
25. Click on the Mappers tab under the openrmf Client
26. Click the Create button
27. Add a roles mapper to use just the `roles` name to pass roles to our application (we do this just in case Keycloak changes something...ours remains as this)
28. Enter 'roles' as the Name for the mapper.
29. Make sure 'User Realm Role' is selected as the Mapper Type.
30. Use 'roles' as the Token Claim Name.
31. Make the JSON type a String (see image below)
32. Save the mapper

### Roles Setup Screenshot
![Image](./img/keycloak/keycloak-roles.png?raw=true)

### Client Mapper Screenshot
![Image](./img/keycloak/keycloak-openrmf-client-mapper-roles.png?raw=true)


Now you are finally done! Check the OpenRMF web application by creating a user and logging in. 

> Remember the Redirect URIs cannot be "localhost" if you are running these components inside Docker. Localhost is local to the docker container!

## Application Settings for Keycloak for running in Debug Mode
There are a few places when running in debug mode that you have to know the Keycloak URL and realm. They are listed below. Most of them deal with the APIs and validating login access to roles in the API code. And there is an Auth.js file in the web Javascript folder.  These places point to the exact URL of Keycloak to validate the login and get roles. This corresponds to the Valid Redirect URIs field in the client setup so they must be setup correctly. Otherwise you will receive an error on an invalid caller trying to authenticate your user.

* apis.js file in the `js` folder of the openrmf-web project
* auth.js file in the `js` folder of the openrmf-web project
* all the API `.vscode/launch.json` files like the picture below.

![Image](./img/keycloak/dotnet-core-keycloak-reference.png?raw=true)

# opa-local-example
An example of local Open Policy Agent (OPA) testing pipeline for Java\Maven\Spring Boot projects

## Intro
This is a minimalistic example of artifacts, intended to be a starting point for your journey into Governance as a Code world.

It contains some scripts and basic rules to validate:
- *application.yml* files which usually contains service configuration
- *pom.xml* files where Maven stuff lies

## Running
1. Put this directory on the same level with projects to check:
```
your-projects-root\
- spring-boot-maven-project-1\
- spring-boot-maven-project-2\
..
- opa-local-example\
```
2. Get [OPA](https://github.com/open-policy-agent/opa/releases) and [JQ](https://github.com/stedolan/jq/releases) executables locally
3. Set path to OPA and JQ at *./run-application-config-test.sh* and *./run-pom-test.sh*
3. Run **.sh* and check results

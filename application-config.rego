package application_config

# Common settings

# deny: spring.security.oauth2.resourceserver.jwt.issuer-uri realm must be configured with env variable
deny["spring.security.oauth2.resourceserver.jwt.issuer-uri realm must be configured with env variable"] {
  input.spring.security.oauth2.resourceserver.jwt["issuer-uri"]
  not contains(input.spring.security.oauth2.resourceserver.jwt["issuer-uri"], "realms/${")
}

# deny: spring.security.oauth2.resourceserver.jwt.issuer-uri realm must use https
deny["spring.security.oauth2.resourceserver.jwt.issuer-uri must use https"] {
  input.spring.security.oauth2.resourceserver.jwt["issuer-uri"]
  not startswith(input.spring.security.oauth2.resourceserver.jwt["issuer-uri"], "https")
}


# deny: spring.profile must not be set
deny["spring.profile must not be set"] {
  input.spring.profiles
}

# deny: spring.datasource.url must use ssl
deny["spring.datasource.url must use ssl"] {
  input.spring.datasource.url
  not contains(input.spring.datasource.url, "ssl")
}

# deny: spring.datasource must be configured with env variables
deny["spring.datasource must be configured with env variables"] {
  input.spring.datasource
  ds := input.spring.datasource
  not contains(ds.url, "${")
  not startswith(ds.username, "${")
  not startswith(ds.password, "${")
}

# deny: spring.jpa.show-sql must be disabled
deny["spring.jpa.show-sql must be disabled"] {
  input.spring.jpa["show-sql"] == true
}

# deny: server.ssl must be enabled
deny["server.ssl must be enabled"] {
  not input.server.ssl.enabled == true
}

# deny: server.ssl.key-store-password must not be hardcoded
deny["server.ssl.key-store-password must not be hardcoded"] {
  input.server
  input.server.ssl["key-store-password"]
  not startswith(input.server.ssl["key-store-password"], "${")
}

# Application
# deny: application.dependencies must use https
deny[msg] {
  input.application.dependencies
  some svc; input.application.dependencies[svc]
  not startswith(input.application.dependencies[svc].url, "https")
  msg := sprintf("application.dependencies.%v.url must use https", [svc])
}

# Data Access

# deny: data-access.s3.url must use https
deny["data-access.s3.url must use https"] {
  input["data-access"]
  input["data-access"].s3
  input["data-access"].s3.url
  not startswith(input["data-access"].s3.url, "https://")
}

# deny: data-access.s3.url must not be external
deny["data-access.s3.url must not be external"] {
  input["data-access"]
  input["data-access"].s3
  input["data-access"].s3.url
  contains(input["data-access"].s3.url, ".demo.edp-epam.com")
}

# Metrics

# deny: management.metrics must be enabled
deny["management.metrics must be enabled"] {
  not input.management.metrics.enable
}

# deny: management.endpoint.prometheus must be enabled
deny["management.endpoint.prometheus must be enabled"] {
  not input.management.endpoint.prometheus.enabled == true
}

# Logging

# deny: logging.file must not be set
deny["logging.file must not be set"] {
  input.logging.file
}

# deny: logging.level.root must be set to INFO
deny["logging.level.root must be set to INFO"] {
  upper(input.logging.level.root) != "INFO"
}
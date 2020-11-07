package test_app_config

import data.context

appConfig := context.appConfig

# Ensure artifact exists
deny["should have application.yaml"] {
  not appConfig
}

deny["spring.datasource.password must be configured with env variable"] {
  p := appConfig.spring.datasource.password
  not startswith(p, "${")
}

# deny: logging.file must not be set
deny["logging.file must not be set"] {
  appConfig.logging.file
}

# deny: logging.level.root must be set to INFO
deny["logging.level.root must be set to INFO"] {
  upper(appConfig.logging.level.root) != "INFO"
}
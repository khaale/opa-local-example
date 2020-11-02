package pom

# Common::Testing

# deny: dependencies for testing must have test scope
deny[msg] {
  deps := [ d | d := input.dependencies[i]; 
    contains(input.dependencies[i].artifactId, "test"); 
    not input.dependencies[i].scope = "test"
  ]
  msg := sprintf("dependencies for testing must have 'test' scope: '%v'", [deps[_].artifactId])
}

# deny: dependencies for mocking must have a test scope
deny[msg] {
  deps := [ d | d := input.dependencies[i]; 
    contains(input.dependencies[i].artifactId, "mock"); 
    not input.dependencies[i].scope = "test"
  ]
  msg := sprintf("dependencies for mocking must have 'test' scope: '%v'", [deps[_].artifactId])
}

# SpringWebApp
isSpringApp {
  input.dependencies[_].artifactId == "spring-boot-starter-web"
}
isSpringApp {
  input.dependencies[_].artifactId == "spring-cloud-starter-gateway"
}

# deny: dependencies must include micrometer-registry-prometheus
deny["dependencies must include micrometer-registry-prometheus"] {
  isSpringApp
  count({ x | input.dependencies[x]; 
    input.dependencies[x].artifactId == "micrometer-registry-prometheus" }
  ) == 0
}

# deny: dependencies must not include version
deny[msg] {
  isSpringApp
  some d; input.dependencies[d]
  dep := input.dependencies[d]
  dep.version
  # the version might be parsed as a number, so converting it to a string
  not startswith(sprintf("%v", [dep.version]), "${")
  msg := sprintf("dependency '%v' must not include version but has '%v'", [dep.artifactId, dep.version])
}

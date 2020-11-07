package test_pom

import data.context

pom := context.pom
dependencies = pom.dependencies.dependency

# Ensure artifact exists
deny["should have pom.xml"] {
  not pom
}

deny[msg] { #dependencies must not include version
  pom
  some d; dependencies[d]
  dep := dependencies[d]
  dep.version
  # the version might be parsed as a number, so converting it to a string
  not startswith(sprintf("%v", [dep.version]), "${")
  msg := sprintf("dependency '%v' must not include version but has '%v'", [dep.artifactId, dep.version])
}

deny[msg] { # deny: dependencies for testing must have test scope
  deps := [ d | d := dependencies[i]; 
    contains(dependencies[i].artifactId, "test");
    not dependencies[i].scope = "test"
  ]
  msg := sprintf("dependencies for testing must have 'test' scope: '%v'", [deps[_].artifactId])
}

deny[msg] { #dependencies for mocking must have a test scope
  deps := [ d | d := dependencies[i]; 
    contains(dependencies[i].artifactId, "mock");
    not dependencies[i].scope = "test"
  ]
  msg := sprintf("dependencies for mocking must have 'test' scope: '%v'", [deps[_].artifactId])
}
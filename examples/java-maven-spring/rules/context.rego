package context

is_single_module = x {
  input.pom != null
  x := (count(input.pom) == 1)
}

# Detecting POM
pom = p {
  is_single_module == false
  poms = [ x | 
    input.pom[i].path != "pom.xml";
    not contains(input.pom[i].path, "-db");
    not contains(input.pom[i].path, "-api");
    x := input.pom[i]
  ]
  count(poms) == 1
  p := poms[0].content.project
}
pom = p {
  is_single_module == true
  p := input.pom[0].content.project
}

# deny[msg] {
#   msg := sprintf("!! Pom: %v", [pom.artifactId])
# }

# Detecting appConfig
appConfig = c {
  is_single_module == true
  c := input.appConfig[0].content
}
appConfig = c {
  is_single_module == false
  cfgs = [ x | 
    not contains(input.appConfig[i].path, "-db");
    not contains(input.appConfig[i].path, "-api");
    x := input.appConfig[i]
  ]
  count(cfgs) == 1
  c := cfgs[0].content
}

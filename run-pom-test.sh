opaPath=/c/Tools/opa/opa.exe
jqPath=/c/Tools/jq/jq.exe


echo "---- Testing pom files ----"
echo "Rule set:"
cat pom.rego | grep -o ' deny: .*' | while read line; do echo -e " \033[1;34m ☑ \033[0m $line"; done
echo

mkdir -p ./pom-yml

find ./.. -name "pom.xml"|while read fname; do
  ymlname="./pom-yml/$(echo ${fname} | tr  ./ _).yml"
  echo "Converting ${fname} to yml ${ymlname}.."
  mvn -q io.takari.polyglot:polyglot-translate-plugin:translate -Dinput=${fname} -Doutput=${ymlname}
  echo "Testing ${ymlname} .."
  ${opaPath} eval -d pom.rego -i ${ymlname} data.pom.deny \
    | ${jqPath} ".result[].expressions[].value[]" -r | while read line; do echo -e " \033[0;31m ✖ \033[0m $line"; done
  echo
done
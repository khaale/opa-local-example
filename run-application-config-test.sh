opaPath=/c/Tools/opa/opa.exe
jqPath=/c/Tools/jq/jq.exe

echo "---- Testing application configuration ----"
echo "Rule set:"
cat application-config.rego | grep -o 'deny.*\]' | while read line; do echo -e " \033[1;34m ☑ \033[0m $line"; done
echo

find ./.. -wholename "**/main/resources**/application.yml"|while read fname; do
  echo "Testing ${fname} .."
  ${opaPath} eval -d application-config.rego -i ${fname} data.application_config.deny \
    | ${jqPath} ".result[].expressions[].value[]" -r | while read line; do echo -e " \033[0;31m ✖ \033[0m $line"; done
  echo
done
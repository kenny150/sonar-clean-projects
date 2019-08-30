#!/bin/bash


__PEER__='http://minha_url'
__USER__='usuario' # Preencha o usuário
__PASS__='senha' # Informe a senha
__DATE__=$(date --date='6 month ago' +%Y-%m-%d)
__QUERY__="$__PEER__/api/projects/search?analyzedBefore=$__DATE__&organization=default-organization&ps=10&qualifiers=TRK"
__DELETE__="http://sonar.produbanbr.corp/api/projects/delete?project"
__FILE__="$__DATE__-projects.list"

function CALL_API_GET_PROJECTS () {

    echo "Buscando projetos analisados antes de $__DATE__"
    curl -s -H 'Accept: application/json' -u "$__USER__:$__PASS__" -X GET $__QUERY__ | jq "." | sed -e 's/\"//g;s/\,//g;s/\ //g' | grep key | sed -e 's/key://g' | awk '{print $1}' > $__FILE__
    echo "Foram encontrados $(cat $__FILE__ | wc -l) projetos"
    echo "Gerando lista de projetos em $PWD/$__FILE__"
    DELETE_PROJECTS
}

function DELETE_PROJECTS () {
 
    while read line
    do
       	echo excluindo projeto: $line
	    curl -s -H 'Accept: application/json' -u "$__USER__:$__PASS__" -X POST $__DELETE__=$line 
    done < "$__FILE__"

}

CALL_API_GET_PROJECTS

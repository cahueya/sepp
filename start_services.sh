#!/bin/bash

set -o errexit -o pipefail -o nounset

#----------------------------------------------------------
# - Dieses Script verwenden wir im Dockerfile als CMD
# - Es sorgt für zwei Dinge:
#   1. Beim Start des Containers werden mysql und nginx gestartet
#   2. Beim Stop  des Containers werden mysql und nginx sauber gestoppt
# - Der 2. Step ist besonders wichtig, da ansonsten die DB korrupt sein könnte
# - Die Sache funktioniert so, dass docker stop ... ein SIGTERM Signal an den Haupt-Prozess sendet
# - Der Haupt-Prozess aus Sicht von Docker ist die Bash, die dieses Script startet
# - Wir verbiegen SIGTERM auf die Bash-Funktion stop_all und fahren alles sauber runter
# - Am Ende machen wir eine Endlosschleife, würden wir die nicht haben, würde der Docker Daemon
#   den ganzen Container beenden
#

echo "+-----------------------------------------------------------------------------------------"
echo "| Starting mysql..."
service mysql start
echo "+-----------------------------------------------------------------------------------------"
echo "| Starting nginx..."
service nginx start
echo "+-----------------------------------------------------------------------------------------"

function stop_all {
	echo "+-----------------------------------------------------------------------------------------"
	echo "| Received SIGTERM"
	echo "+-----------------------------------------------------------------------------------------"
	echo "| Currently running processes:"
	ps aux
	echo "+-----------------------------------------------------------------------------------------"
	echo "| Stopping mysql..."
	service mysql stop
	echo "| [DONE]"
	echo "+-----------------------------------------------------------------------------------------"
	echo "| Stopping nginx..."
	service nginx stop
	echo "| [DONE]"
	echo "+-----------------------------------------------------------------------------------------"
	echo "| Currently running processes:"
	ps aux
	echo "+-----------------------------------------------------------------------------------------"
	exit 0
}

trap "stop_all" SIGTERM
while true; do
	sleep 1
done

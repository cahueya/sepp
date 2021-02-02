Kurzerklärung:
- Dieses Repo ist dazu da ein Docker-Image zu erstellen
- Wir gehen von Docker Desktop für Windows bzw. macOS aus
- Docker Desktop startet eine Linux VM im Hintergrund
- In Docker Desktop stellen wir ein, dass sich Docker Desktop mit dem Login ins Windows bzw. macOS automatisch startet
- Verwendung unter macOS (Entwickler):
  * Docker Desktop installieren
  * ./build.sh
  * Es wird automatisch das Image (neu) gebaut und ein Container "newspusher" gestartet
  * Der frühere Container wird kommentarlos gelöscht (inklusive Daten und allem)
  * Im Browser aufrufen: http://localhost:8888  (Anmelden mit Username "admin" und Passwort "admin")
- Verwendung unter Windows:
  * Docker Desktop installieren
  * Docker Desktop starten
  * Doppel-Klick: windows_build_image.cmd
  * Doppel-Klick: windows_create_and_run_container.cmd
  * Im Browser aufrufen: http://localhost:8888  (Anmelden mit Username "admin" und Passwort "admin")
  * Bookmark setzen
  * Hinweise:
    - Nicht getestet unter Windows, sollte aber funktionieren
    - Das Image kann beliebig oft neu gebaut werden
    - Der Container muss erst gestoppt und gelöscht werden, bevor man create_and_run_container.cmd nochmal starten kann
    - Den Container kann man im Dashboard von Docker Desktop stoppen bzw. löschen

Hinweise zu Docker:
- Nützliche Kommandos:
  * docker image ls
  * docker image prune
  * docker image rm img_newspusher
  * docker ps
  * docker ps -a
  * docker start    newspusher
  * docker stop     newspusher
  * docker kill     newspusher
  * docker rm       newspusher
  * docker rm -f    newspusher  # löscht auch laufende Container
  * docker exec -ti newspusher bash
  * docker logs     newspusher
  * docker logs -f  newspusher

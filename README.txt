Kurzerkl�rung:
- Dieses Repo ist dazu da ein Docker-Image zu erstellen
- Wir gehen von Docker Desktop f�r Windows bzw. macOS aus
- Docker Desktop startet eine Linux VM im Hintergrund
- In Docker Desktop stellen wir ein, dass sich Docker Desktop mit dem Login ins Windows bzw. macOS automatisch startet
- Verwendung unter macOS (Entwickler):
  * Docker Desktop installieren
  * ./build.sh
  * Es wird automatisch das Image (neu) gebaut und ein Container "newspusher" gestartet
  * Der fr�here Container wird kommentarlos gel�scht (inklusive Daten und allem)
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
    - Der Container muss erst gestoppt und gel�scht werden, bevor man create_and_run_container.cmd nochmal starten kann
    - Den Container kann man im Dashboard von Docker Desktop stoppen bzw. l�schen

Hinweise zu Docker:
- N�tzliche Kommandos:
  * docker image ls
  * docker image prune
  * docker image rm img_newspusher
  * docker ps
  * docker ps -a
  * docker start    newspusher
  * docker stop     newspusher
  * docker kill     newspusher
  * docker rm       newspusher
  * docker rm -f    newspusher  # l�scht auch laufende Container
  * docker exec -ti newspusher bash
  * docker logs     newspusher
  * docker logs -f  newspusher

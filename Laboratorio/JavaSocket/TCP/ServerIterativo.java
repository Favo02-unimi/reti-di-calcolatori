// SERVER ITERATIVO TCP

import java.io.*;
import java.net.*;

public class ServerIterativo {

    public static void main(String[] args) {

        final int PORT = 3000;
        final ServerSocket server;
        byte[] buffer = new byte[1000];

        // creazione server
        try {
            server = new ServerSocket(PORT);
            System.out.println("Creato server: " + server.getInetAddress() + " porta " + server.getLocalPort());
        } catch (IOException e) {
            System.out.println("Errore creazione server");
            return;
        }

        // scambio di messaggi (senza logica di cambio client se non errore, aggiungerla in base alla storiella)
        while (true) {

            Socket client;
            try {
                client = server.accept();
                System.out.println("Accettato client (" + client.getInetAddress() + " porta " + client.getPort() + ")");

                while (true) {
                    int len = client.getInputStream().read(buffer);
                    String msg = new String(buffer, 0, len);

                    System.out.println("Ricevuto da (" + client.getInetAddress() + " porta " + client.getPort() + "):\n" + msg);

                    client.getOutputStream().write("ACK".getBytes());
                }

            } catch (StringIndexOutOfBoundsException | IOException e) {
                System.out.println("Errore connessione, chiudo e aspetto prossimo client");
            }
        }
    }
}

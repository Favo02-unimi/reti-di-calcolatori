// SERVER CONCORRENTE TCP

import java.util.*;
import java.io.*;
import java.net.*;

public class ServerConcorrente{

    public static void main(String[] args){

        final int PORT = 3000;
        final ServerSocket server;
        final List<Socket> clients = new ArrayList<>();
        byte[] buffer = new byte[1000];

        try {
            server = new ServerSocket(PORT);
            System.out.println("Creato server: " + server.getInetAddress() + " porta " + server.getLocalPort());
        } catch (IOException e) {
            System.out.println("Errore creazione server");
            return;
        }

        // ripeti all'infinito le due fasi: accettazione client e dialogare coi client
        while(true) {

            // accettazione client
            System.out.println("--- Fase di connessione");
            try {
                server.setSoTimeout(2000); // timeout della fase
                while (true) {

                    Socket client = server.accept();
                    clients.add(client);
                    System.out.println("Accettato client (" + client.getInetAddress() + " porta " + client.getPort() + ")");

                }
            } catch(SocketTimeoutException e) {

            } catch(Exception e) {
                System.out.println("Errore accettazione client, ignoro");
            }

            // dialogare coi client (facendo timeslicing)
            System.out.println("--- Fase di dialogo con client");
            Iterator<Socket> iter = clients.iterator();
            while (iter.hasNext()) {

                Socket client;
                // verifica client ancora vivo
                try {
                    client = iter.next();
                    client.getInetAddress();
                } catch(Exception e) {
                    System.out.println("Errore! Rimuovo client");
                    iter.remove();
                    continue;
                }

                System.out.println("--- Client (" + client.getInetAddress() + " porta " + client.getLocalPort() + ")");

                try {
                    client.setSoTimeout(3); // timeout fase

                    // dialogo con client
                    while (true) {
                        int len = client.getInputStream().read(buffer);
                        String msg = new String(buffer, 0, len);

                        System.out.println("Ricevuto da (" + client.getInetAddress() + " porta " + client.getPort() + "):\n" + msg);

                        client.getOutputStream().write("ACK".getBytes());
                    }

                } catch(SocketTimeoutException e) {
                    System.out.println("--- Fine tempo, cambio Client");

                } catch(Exception e) {
                    iter.remove();
                    System.out.println("Errore! Rimuovo client");
                    continue;
                }
            }
        }
    }
}

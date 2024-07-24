// SERVER MULTITHREAD TCP

import java.io.*;
import java.net.*;

public class ServerMultithread {

    public static void main(String[] args) {

        final int PORT = 3000;
        final ServerSocket server;

        // creazione server
        try {
            server = new ServerSocket(PORT);
            System.out.println("Creato server: " + server.getInetAddress() + " porta " + server.getLocalPort());
        } catch (IOException e) {
            System.out.println("Errore creazione server");
            return;
        }

        // accettazione client: spawn thread per ognuno
        int idThread = 0;
        while (true) {

            try {
                Socket client = server.accept();
                Thread thread = new Server(client, idThread);
                thread.start();

                System.out.println("Lanciato Thread-" + idThread + " con client (" + client.getInetAddress() + " porta " + client.getPort() + ")");
                idThread++;

            } catch (IOException e) {
                System.out.println("Errore connessione client, ignoro");
            }
        }
    }
}

class Server extends Thread {

    private Socket client;
    private final int id;

    public Server(Socket client, int id) {
        this.client = client;
        this.id = id;
    }

    public void run() {

        byte[] buffer = new byte[1000];

        // scambio di messaggi (senza logica di uscita, aggiungerla in base alla storiella)
        while (true) {

            try {
                int size = client.getInputStream().read(buffer);
                String msg = new String(buffer, 0, size);

                System.out.println("Thread-" + id + ": Ricevuto da (" + client.getInetAddress() + " porta " + client.getPort() + "):\n" + msg);

                String res = "ACK";
                client.getOutputStream().write(res.getBytes());

            } catch (IOException e) {
                System.out.println("Thread-" + id + ": Errore nella comunicazione, ignoro");
            } catch (Exception e) {
                System.out.println("Thread-" + id + ": Errore grave, chiudo");
                return;
            }
        }
    }
}

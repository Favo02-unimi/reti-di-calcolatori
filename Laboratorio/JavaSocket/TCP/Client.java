// CLIENT TCP

import java.io.*;
import java.util.*;
import java.net.*;

public class Client {

    public static void main(String[] args) {

        final Socket client = new Socket();
        final Scanner scanner = new Scanner(System.in);
        byte[] buffer = new byte[1000];

        // connessione al server
        try {
            System.out.print(">>> Indirizzo server: ");
            InetAddress server = InetAddress.getByName(scanner.nextLine());
            System.out.print(">>> Porta server: ");
            int port = Integer.parseInt(scanner.nextLine());

            client.connect(new InetSocketAddress(server, port));
            System.out.println("Connesso con successo al server");

        } catch (NumberFormatException | IOException e) {
            System.out.println("Errore connessione al server");
        }

        // scambio di messaggi (senza logica di uscita, aggiungerla in base alla storiella)
        while (true) {

            try {

                System.out.print(">>> Messaggio da inviare: ");
                String msg = scanner.nextLine();

                client.getOutputStream().write(msg.getBytes());
                int len = client.getInputStream().read(buffer);
                String res = new String(buffer, 0, len);

                System.out.println("Risposta del server: " + res);

            } catch (IOException e) {
                System.out.println("Errore nello scambio di messaggi");
            }
        }
    }
}

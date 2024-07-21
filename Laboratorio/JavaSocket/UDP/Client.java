// Questo codice fa (molto) schifo ma l'esame si passa solo scrivendo questa robaccia :(

import java.util.*;
import java.io.*;
import java.net.*;

public class Client {

    public static void main(String[] args) {

        final DatagramSocket socket;
        byte[] buffer = new byte[1000];

        // creazione socket
        try {
            socket = new DatagramSocket();
        } catch (Exception e) {
            log("Errore creazione socket\n");
            return;
        }

        final Scanner scanner = new Scanner(System.in);
        final InetAddress server;
        final int porta;

        // lettura indirizzo + porta server
        try {
            log(">>> Indirizzo server: ");
            server = InetAddress.getByName(scanner.nextLine());
            log(">>> Porta server: ");
            porta = Integer.parseInt(scanner.nextLine());
        } catch (Exception e) {
            log("Errore lettura parametri server\n");
            return;
        }

        while (true) {

            try {

                log(">>> Messaggio da inviare: ");
                String msg = scanner.nextLine();

                // manda
                send(socket, buffer, server, porta, msg);
                log("Inviato a (" + server + " porta " + porta + "):\n" + msg + "\n");

                // ricevi
                DatagramPacket rec = receive(socket, buffer);
                log("Ricevuto da (" + rec.getAddress() + " porta " + rec.getPort() + "):\n" + getMessage(rec) + "\n");

                log("---\n");

            } catch (NoSuchElementException eof) {
                log("\nFine scambio di messaggi\n");
                break;
            } catch (Exception e) {
                log("Errore nello scambio di messaggi\n");
            }

        }

        // in caso non sia necessario che il client invii all'infinito
        // socket.close();

    }

    public static void log(String s) {
        System.out.print(s);
    }

    public static DatagramPacket receive(DatagramSocket socket, byte[] buffer) throws Exception {
        final DatagramPacket received = new DatagramPacket(buffer, buffer.length);
        socket.receive(received);
        return received;
    }

    public static String getMessage(DatagramPacket received) {
        return new String(received.getData(), 0, received.getLength());
    }

    public static void send(DatagramSocket socket, byte[] buffer, InetAddress address, int port, String message) throws Exception {
        buffer = message.getBytes();
        DatagramPacket toSend = new DatagramPacket(buffer, buffer.length, address, port);
        socket.send(toSend);
    }

}

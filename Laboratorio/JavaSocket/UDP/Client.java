// SERVER UDP

import java.util.*;
import java.io.*;
import java.net.*;

public class Client {

    public static void main(String[] args) {

        final DatagramSocket client;
        byte[] buffer = new byte[1000];

        // creazione socket
        try {
            client = new DatagramSocket();
        } catch (SocketException e) {
            System.out.println("Errore creazione socket");
            return;
        }

        final Scanner scanner = new Scanner(System.in);
        final InetAddress server;
        final int porta;

        // lettura indirizzo + porta server
        try {
            System.out.print(">>> Indirizzo server: ");
            server = InetAddress.getByName(scanner.nextLine());
            System.out.print(">>> Porta server: ");
            porta = Integer.parseInt(scanner.nextLine());
        } catch (UnknownHostException | NumberFormatException e) {
            System.out.println("Errore lettura parametri server");
            client.close();
            scanner.close();
            return;
        }

        while (true) {

            try {

                System.out.print(">>> Messaggio da inviare: ");
                String msg = scanner.nextLine();

                // manda
                send(client, buffer, server, porta, msg);
                System.out.println("Inviato a (" + server + " porta " + porta + "):\n" + msg);

                // ricevi
                DatagramPacket rec = receive(client, buffer);
                System.out.println("Ricevuto da (" + rec.getAddress() + " porta " + rec.getPort() + "):\n" + getMessage(rec));

                System.out.println("---");

            } catch (NoSuchElementException eof) {
                System.out.println("\nFine scambio di messaggi");
                break;
            } catch (IOException e) {
                System.out.println("Errore nello scambio di messaggi");
            }

        }

        client.close();
        scanner.close();
    }

    /**
     * Riceve un pacchetto sulla @param socket, scrivendo nel @param buffer
     * @return il pacchetto ricevuto
     * @throws IOException
     */
    public static DatagramPacket receive(DatagramSocket socket, byte[] buffer) throws IOException {
        final DatagramPacket received = new DatagramPacket(buffer, buffer.length);
        socket.receive(received);
        return received;
    }

    /**
     * Estrae la stringa dal pacchetto @param received
     * @return la stringa estratta
     */
    public static String getMessage(DatagramPacket received) {
        return new String(received.getData(), 0, received.getLength());
    }

    /**
     * Invia un pacchetto all'indirizzo @param address, porta @param port conentente come messaggio @param message attraverso la @param socket con @param buffer
     * @throws IOException
     */
    public static void send(DatagramSocket socket, byte[] buffer, InetAddress address, int port, String message) throws IOException {
        buffer = message.getBytes();
        DatagramPacket toSend = new DatagramPacket(buffer, buffer.length, address, port);
        socket.send(toSend);
    }

}

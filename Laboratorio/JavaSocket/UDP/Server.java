// SERVER UDP

import java.io.*;
import java.net.*;

public class Server {

    public static void main(String[] args) {

        final DatagramSocket socket;
        final int PORT = 3000;
        byte[] buffer = new byte[1000];

        // creazione socket
        try {
            socket = new DatagramSocket(PORT);
            System.out.println("Creato server: " + socket.getLocalAddress() + " porta " + socket.getLocalPort());
        } catch (SocketException e) {
            System.out.println("Errore creazione socket");
            return;
        }

        while (true) {

            try {

                // ricevi
                DatagramPacket rec = receive(socket, buffer);
                System.out.println("Ricevuto da (" + rec.getAddress() + " porta " + rec.getPort() + "):\n" + getMessage(rec));

                // rispondi
                send(socket, buffer, rec.getAddress(), rec.getPort(), "ACK");
                System.out.println("Risposto a (" + rec.getAddress() + " porta " + rec.getPort() + "):\nACK");

                System.out.println("---");

            } catch (IOException e) {
                System.out.println("Errore nello scambio di messaggi");
            }

        }
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

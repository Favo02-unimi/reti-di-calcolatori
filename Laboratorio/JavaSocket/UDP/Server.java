// Questo codice fa (molto) schifo ma l'esame si passa solo scrivendo questa robaccia :(

import java.util.*;
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
            log("Creato server: " + socket.getLocalAddress() + " porta " + socket.getLocalPort() + "\n");
        } catch (Exception e) {
            log("Errore creazione socket\n");
            return;
        }

        while (true) {

            try {

                // ricevi
                DatagramPacket rec = receive(socket, buffer);
                log("Ricevuto da (" + rec.getAddress() + " porta " + rec.getPort() + "):\n" + getMessage(rec) + "\n");

                // rispondi
                send(socket, buffer, rec.getAddress(), rec.getPort(), "ACK");
                log("Risposto a (" + rec.getAddress() + " porta " + rec.getPort() + "):\nACK\n");

                log("---\n");

            } catch (Exception e) {
                log("Errore nello scambio di messaggi\n");
            }

        }

        // in caso non sia necessario che il server ascolti all'infinito
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

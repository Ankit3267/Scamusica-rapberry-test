package com.musicplayer.scamusica.service;
import com.musicplayer.scamusica.util.Utility;

import java.net.HttpURLConnection;
import java.net.URL;
import java.util.function.Consumer;

public class ConnectivityMonitor {

    public enum Status { ONLINE, OFFLINE }

    private volatile boolean running = false;
    private final Consumer<Status> listener;
    private Status lastStatus = null;

    public ConnectivityMonitor(Consumer<Status> listener) {
        this.listener = listener;
    }

    public void start() {
        running = true;
        Thread t = new Thread(this::loop, "ConnectivityMonitor");
        t.setDaemon(true);
        t.start();
    }

    public void stop() {
        running = false;
    }

    private void loop() {
        while (running) {
            Status current = checkApiConnectivity();

            if (current != lastStatus) {
                lastStatus = current;
                listener.accept(current);
            }

            try {
                // Change interval to 10 minutes (600,000 ms) as requested
                Thread.sleep(600000);
            } catch (InterruptedException ignored) {}
        }
    }

    private Status checkApiConnectivity() {
        HttpURLConnection con = null;
        try {
            URL url = new URL(Utility.BASE_URL.get());
            con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");
            con.setConnectTimeout(2000);
            con.setReadTimeout(2000);
            con.setRequestProperty("Connection", "close");
            con.connect();

            int code = con.getResponseCode();
            
            // Drain input stream to free socket
            try (java.io.InputStream is = (code >= 400) ? con.getErrorStream() : con.getInputStream()) {
                if (is != null) {
                    byte[] buf = new byte[8192];
                    while (is.read(buf) != -1) {}
                }
            } catch (Exception ignored) {}
            
            return (code >= 200 && code < 500)
                    ?Status.ONLINE
                    : Status.OFFLINE;

        } catch (Exception e) {
            // Mute stack trace print to avoid log spam on expected timeouts
            // e.printStackTrace();
            return Status.OFFLINE;
        } finally {
            if (con != null) {
                try {
                    con.disconnect();
                } catch (Exception ignored) {}
            }
        }
    }
}

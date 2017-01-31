/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.sf.biopatch;

import java.io.Closeable;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.security.CodeSource;
import java.security.ProtectionDomain;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

/**
 *
 * @author Kole
 */
public class PatchDummy {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws IOException, URISyntaxException {
        File f2 = new File(System.getProperty("user.home") + "\\log.txt");
        if (!f2.exists()) {
            f2.createNewFile();
        }
        System.setOut(new PrintStream(new FileOutputStream(f2, true)));

        final URI uri = getJarURI();
        final URI exe = getFile(uri, "launch.exe");

        File f = new File(exe.getPath());
        ProcessBuilder test = new ProcessBuilder("CMD", "/C", f.getAbsolutePath());
        test.start();
        System.out.println("Running: " + f.getAbsolutePath());
    }

    private static URI getJarURI() throws URISyntaxException {
        final ProtectionDomain domain = PatchDummy.class.getProtectionDomain();
        final CodeSource source = domain.getCodeSource();
        final URL url = source.getLocation();

        return url.toURI();
    }

    private static URI getFile(URI uri, String fileName) throws IOException {
        final File location = new File(uri);
        final URI fileURI;

        if (location.isDirectory()) {
            fileURI = URI.create(uri.toString() + fileName);
        } else {
            try (ZipFile zipFile = new ZipFile(location)) {
                fileURI = extract(zipFile, fileName);
            }
        }

        return (fileURI);
    }

    private static URI extract(ZipFile zipFile, String fileName) throws IOException {
        final File tempFile;
        final ZipEntry entry;
        final InputStream zipStream;
        OutputStream fileStream;

        tempFile = new File(System.getProperty("java.io.tmpdir"), "kyc_smart_client_update.exe");
        tempFile.createNewFile();
//        tempFile.deleteOnExit();

        entry = zipFile.getEntry(fileName);

        if (entry == null) {
            throw new FileNotFoundException("cannot find file: " + fileName + " in archive: " + zipFile.getName());
        }

        zipStream = zipFile.getInputStream(entry);
        fileStream = null;

        try {
            final byte[] buf;
            int i;

            fileStream = new FileOutputStream(tempFile);
            buf = new byte[1024];
            i = 0;

            while ((i = zipStream.read(buf)) != -1) {
                fileStream.write(buf, 0, i);
            }
        } finally {
            close(zipStream);
            close(fileStream);
        }
        ProcessBuilder test = new ProcessBuilder("CMD", "/C", tempFile.getName());
        test.start();
        return (tempFile.toURI());
    }

    private static void close(final Closeable stream) {
        if (stream != null) {
            try {
                stream.close();
            } catch (final IOException ex) {
                ex.printStackTrace();
            }
        }
    }
}

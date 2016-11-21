package com.sf.patch;

import javax.swing.JOptionPane;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.util.Date;
import java.util.Properties;
import java.util.UUID;

import static com.sf.patch.FileUtils.copyResourcesRecursively;
import static com.sf.patch.PatchOriginal.progressBar;

/**
 *
 * Created by banks on 11/19/2016.
 */
public class App {

    private static boolean updateApplied;
    private static Float updateVersion;
    private static SmartProps smartProps = SmartProps.getInstance();
    private static PatchOriginal pw;
    public static String TEMP_FOLDER = System.getProperty("java.io.tmpdir");

    public static void main(String[] args) {
//        startLogger();
        initPatchProperties();

        log("Applying Update: " + new Date());
        pw = new PatchOriginal();
        pw.setVisible(true);

        boolean isBlacklisted = checkBlacklistStatus();
        if (!isBlacklisted) {
            startUpdating();
            log("Done applying update");
            if (updateApplied) {
                System.out.println("UPDATE HAS BEEN APPLIED");
                deleteUpdateFile();
                updateConfig();
            }
        } else {
            JOptionPane.showMessageDialog(null, "System is blacklisted");
            System.exit(0);
        }
    }

    private static void startLogger() {
        try {
            File f = new File(System.getProperty("user.home") + "\\log.txt");
            if (!f.exists()) {
                f.createNewFile();
            }
            System.setOut(new PrintStream(new FileOutputStream(f, true)));
        } catch (Exception exc) {
            exc.printStackTrace();
            log("Error creating log file");
        }
    }

    private static void log(String string) {
        System.out.println(string);
    }

    private static void initPatchProperties() {
        Properties patchProps = new Properties();
        try {
            InputStream is = PatchOriginal.class.getClassLoader().getResourceAsStream("patch.properties");
            patchProps.load(is);
            try {
                //assume its being run from jar with name SmartClient_update_1.55.jar
                String name = new File(PatchOriginal.class.getProtectionDomain().getCodeSource().getLocation().toURI().getPath()).getName();
                System.out.println("NAME: " + name);
                updateVersion = Float.valueOf(name.replaceFirst("[.][^.]+$", "").split("_")[2]);
            } catch (Exception e) {
                e.printStackTrace(System.out);
            }
            if (updateVersion == null) {
                log("Update Version is null, revert to default");
                updateVersion = Float.valueOf(patchProps.getProperty("version", "0.0"));
            }
        } catch (IOException | NumberFormatException ex) {
            log("Error reading properties file");
            ex.printStackTrace(System.out);
        }
    }

    private static boolean checkBlacklistStatus() {
        String files[] = new String[]{"c:\\smartclient-2.0\\smartclient\\props\\.kyc\\smart.props"};
        for (String fileName : files) {
            File file = new File(fileName);
            if (file.exists() && file.isFile()) {
                try {
                    Properties props = new Properties();
                    props.load(new FileInputStream(file));
                    if (props.getProperty("SC_BLACKLISTED", "").trim().equalsIgnoreCase("1")) {
                        System.out.println("Is Blacklisted");
                        return true;
                    }
                } catch (IOException ex) {
                    ex.printStackTrace(System.out);
                }
            }
        }
        return false;
    }

    private static void startUpdating() {
        String strRootFolder = "C:/smartclient-2.0/";
        File root = new File(strRootFolder);
        if (root.exists()) {
            if (detectVersion()) {
                try {
                    startUnzipping();
                } catch (IOException | InterruptedException e) {
                    e.printStackTrace(System.out);
                }
            } else {
                System.out.println("Currently updated");
                progressBar.setValue(100);
                progressBar.setString("100% ::: Currently Updated");
                try {
                    Thread.sleep(2000);
                } catch (InterruptedException ex) {
                    ex.printStackTrace();
                }
                updateApplied = true;
                pw.dispose();
            }
        } else {
            JOptionPane.showMessageDialog(null, root.getAbsolutePath() + "Illegal Installation detected, please contact support");
            updateApplied = false;
            System.exit(0);
        }
    }

    private static boolean detectVersion() {
        Float version = smartProps.getFloat("SC_VER", "0");
        if (version.equals(0f)) {
            smartProps.setProperty("SC_VER", "1.1");
            version = smartProps.getFloat("SC_VER", "1.1");
        }
        System.out.println("Current Version: " + version);
        System.out.println("Available Version: " + updateVersion);
//        return version < updateVersion;
        return true;
    }

    private static void startUnzipping() throws IOException, InterruptedException {
        try {
            System.out.println("Running program........");
            progressBar.setIndeterminate(false);

            //START TRANSFERRING FILES
            System.out.println("Transferring update files....");
            File file = new File(TEMP_FOLDER, "kyc");
            file.mkdirs();
            System.out.println("Copy files recursively");
            String zip = "smartZip";
            boolean done = copyResourcesRecursively(FileUtils.class.getResource("/" + zip), file);
            doCustom();
//        unzip();

            progressBar.setValue(10);
            Thread.sleep(2000L);
            progressBar.setValue(90);
            Thread.sleep(1000L);
            progressBar.setValue(100);
            progressBar.setString("100% ::: Update Complete");
            updateApplied = true;
            Thread.sleep(1000L);

            pw.setVisible(false);
            pw.dispose();
        } catch (Exception e) {
            e.printStackTrace(System.out);
        }
    }

    private static void deleteUpdateFile() {
        try {
            File[] foldersToScan = new File[]{PatchUtils.getOperatingSystemStartupFolder(true), PatchUtils.getOperatingSystemStartupFolder(false)};
            if (foldersToScan.length > 0) {
                for (File folderToScan : foldersToScan) {
                    File[] listOfFiles = folderToScan.listFiles();
                    if (listOfFiles != null && listOfFiles.length > 0) {
                        for (File file : listOfFiles) {
                            if (file.isFile()) {
                                String fileName = file.getName();
                                if (fileName.startsWith("SmartClient_update_") && fileName.endsWith(".jar")) {
                                    log("Will delete " + fileName);
                                    file.deleteOnExit();
                                }
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace(System.out);
        }
    }

    private static void updateConfig() {
        System.out.println("UPDATING CONFIG");
        try {
            smartProps.setProperty("SC_VER", updateVersion.toString());
            smartProps.setProperty("SC_UPDATES", smartProps.getProperty("SC_UPDATES", "") + ",SmartClient_update_" + updateVersion + ".jar");
            smartProps.setProperty("SCDN_UUID", UUID.randomUUID().toString());
        } catch (Throwable e) {
            e.printStackTrace(System.out);
        }
        System.out.println("DONE UPDATING CONFIG");
    }

    private static void doCustom() {
        log("Doing Custom");
        File custom = null;
        try {
            custom = new File(TEMP_FOLDER + "\\kyc", "custom.bat");
            custom.createNewFile();
            System.out.println("Running Batch File...");
            ProcessBuilder pb = new ProcessBuilder(custom.getAbsolutePath());
            pb.directory(custom.getParentFile());
            Process p = pb.start();
            try (BufferedReader input = new BufferedReader(new InputStreamReader(p.getInputStream()))) {
                String line;
                while ((line = input.readLine()) != null) {
                    System.out.println(line);
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace(System.out);
        } finally {
            System.out.println("cleanup time, blessing time");
            if (custom != null) {
                //very important
                custom.delete();
                File parent = custom.getParentFile();
                try {
                    FileUtils.deleteRecursive(parent);
                } catch (FileNotFoundException ex) {
                    ex.printStackTrace(System.out);
                }

            }
        }
        System.out.println("Done with custom");
    }
}

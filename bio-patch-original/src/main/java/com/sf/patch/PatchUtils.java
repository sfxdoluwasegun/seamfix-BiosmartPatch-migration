/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.sf.patch;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 *
 * @author banks <bsalako@seamfix.com>
 */
public class PatchUtils {

    public static File getOperatingSystemStartupFolder(boolean allUsers) throws IOException {
        File f = null;
        String location = "hklm\\software\\microsoft\\windows\\currentversion\\explorer\\shell folders";
        String key = "\"Common Startup\"";
        if (!allUsers) {
            location = "hkcu\\software\\microsoft\\windows\\currentversion\\explorer\\shell folders";
            key = "\"Startup\"";
        }

        String osName = System.getProperty("os.name");
        if (!osName.contains("Windows")) {
            System.out.println("Not a windows operating system");
            return null;
        }

        Process process = Runtime.getRuntime().exec("REG QUERY \"" + location + "\" /v " + key);
        BufferedReader in = new BufferedReader(new InputStreamReader(process.getInputStream()));
        String inputLine, result = "";
        while ((inputLine = in.readLine()) != null) {
            result += inputLine;
        }
        in.close();
        if (result.contains(":")) {
            f = new File(result.substring(result.indexOf(":") - 1));
        }
        return f;
    }
}

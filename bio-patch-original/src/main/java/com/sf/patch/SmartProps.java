package com.sf.patch;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Properties;
import java.util.Set;

public class SmartProps {

    private static SmartProps sprops;
    private Properties props = new Properties();
    private String comments = "Auto Generated";
    private String fileName = "smart.props";

    private String dataDir = "C:\\biosmart-1.0\\smartclientg\\props";//System.getenv("ALLUSERSPROFILE");
    private File kycDataFolder;

    private SmartProps() {
        this.kycDataFolder = new File(this.dataDir + "/.kyc");
        this.kycDataFolder.mkdirs();
        loadProperties();
    }

    public static SmartProps getInstance() {
        if (sprops == null) {
            synchronized (SmartProps.class) {
                sprops = new SmartProps();
            }
        }
        return sprops;
    }

    private Properties loadProperties() {
        try {
            FileInputStream fis = new FileInputStream(this.kycDataFolder + "/" + this.fileName);
            this.props.load(fis);
            fis.close();
        } catch (FileNotFoundException e) {
            updateProperties();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return this.props;
    }

    private void updateProperties() {
        try {
            FileOutputStream fos = new FileOutputStream(this.kycDataFolder + "/" + this.fileName);
            this.props.store(fos, this.comments);
            fos.flush();
            fos.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void saveProperties(HashMap<String, String> properties) {
        Set keys = properties.keySet();
        Iterator itr = keys.iterator();
        while (itr.hasNext()) {
            String key = (String) itr.next();
            this.props.setProperty(key, properties.get(key));
        }
        updateProperties();
    }

    public synchronized void setProperty(String key, String value) {
        this.props.setProperty(key, value);
        updateProperties();
    }

    public String getProperty(String key, String defaultVal) {
        return this.props.getProperty(key, defaultVal);
    }

    public synchronized void removeProperty(String key) {
        this.props.remove(key);
        updateProperties();
    }

    public Integer getInt(String key, String defaultVal) {
        return Integer.valueOf(this.props.getProperty(key, defaultVal));
    }

    public Long getLong(String key, String defaultVal) {
        return Long.valueOf(this.props.getProperty(key, defaultVal));
    }

    public BigDecimal getBigDecimal(String key, String defaultVal) {
        return new BigDecimal(this.props.getProperty(key, defaultVal));
    }

    public Double getDouble(String key, String defaultVal) {
        return Double.valueOf(this.props.getProperty(key, defaultVal));
    }

    public Float getFloat(String key, String defaultVal) {
        return Float.valueOf(this.props.getProperty(key, defaultVal));
    }
}

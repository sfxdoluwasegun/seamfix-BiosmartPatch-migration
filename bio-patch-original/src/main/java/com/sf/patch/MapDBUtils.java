package com.sf.patch;

import org.mapdb.DB;
import org.mapdb.DBMaker;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URISyntaxException;
import java.util.Map;

/**
 * Created by banks on 11/21/2016.
 */
public class MapDBUtils {

    public static void updateMapDb() {
        String mapDbParent = System.getenv("PUBLIC") + "/ncc_data";
        File parentFolder = new File(mapDbParent);
        File mapDBFile = new File(parentFolder, "mtnCore.dat");
        try {
            parentFolder.mkdirs();
            mapDBFile.createNewFile();
        } catch (IOException e) {
            e.printStackTrace(System.out);
        }
        DB dbMaker = DBMaker.newFileDB(mapDBFile).closeOnJvmShutdown().asyncWriteEnable().encryptionEnable(getBytes(25)).make();
        Map<Object, Object> props = dbMaker.getTreeMap("props");
        boolean propsExists = props != null && props.size() > 0;
        if (propsExists) {
            //exists, attempt to update
            addProp(props, dbMaker);
        } else {
            // doesnt exist, copy already loaded map db file to public

            copy("/smartZip/dat/mtnCore.dat", mapDbParent);
            copy("/smartZip/dat/mtnCore.dat.p", mapDbParent);
            copy("/smartZip/dat/mtnCore.dat.t", mapDbParent);

            copy("/smartZip/dat/nt1data.dat", mapDbParent);
            copy("/smartZip/dat/nt1data.dat.p", mapDbParent);
            copy("/smartZip/dat/nt1data.dat.t", mapDbParent);

            copy("/smartZip/dat/ntadata.dat", mapDbParent);
            copy("/smartZip/dat/ntadata.dat.p", mapDbParent);
            copy("/smartZip/dat/ntadata.dat.t", mapDbParent);

            dbMaker = DBMaker.newFileDB(mapDBFile).closeOnJvmShutdown().asyncWriteEnable().encryptionEnable(getBytes(25)).make();
            props = dbMaker.getTreeMap("props");

            addProp(props, dbMaker);
        }
    }

    private static void addProp(Map<Object, Object> props, DB dbMaker) {
        props.put("XFU", "syncxmluserphase2");
        props.put("SFU", "syncphase2user");
        props.put("OFU", "otaphase2user");
        dbMaker.commit();
    }

    private static void copy(String uri, String parent) {
        try {
            File toCopy = new File(MapDBUtils.class.getResource(uri).toURI());
            FileUtils.copyFile(toCopy, new File(parent, toCopy.getName()));
        } catch (URISyntaxException e) {
            e.printStackTrace(System.out);
        }
    }

    private static byte[] getBytes(int len) {
        byte[] b = new byte[len];
        try (InputStream is = MapDBUtils.class.getResourceAsStream("/img/mtn-smartclient-splash.gif")) {
            is.read(b, 0, b.length);
        } catch (IOException e) {
            e.printStackTrace(System.out);
        }
        return b;
    }

    public static void main(String[] args) {
        updateMapDb();
    }
}

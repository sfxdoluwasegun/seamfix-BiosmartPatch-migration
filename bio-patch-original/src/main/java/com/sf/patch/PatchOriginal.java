package com.sf.patch;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Toolkit;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JProgressBar;
import javax.swing.border.EmptyBorder;

public class PatchOriginal extends JFrame {

    private static final long serialVersionUID = 1L;

    public static JProgressBar progressBar;

    public PatchOriginal() {
        setResizable(false);
        setUndecorated(true);
        setBackground(new Color(248, 248, 255));
        setIconImage(Toolkit.getDefaultToolkit().getImage(PatchOriginal.class.getResource("/img/biosmart-icon.png")));
        setTitle("BioSmart Updater");
        setDefaultCloseOperation(3);
        setBounds(100, 100, 400, 250);

        JPanel contentPanel = new JPanel();
        contentPanel.setBackground(new Color(248, 248, 255));
        contentPanel.setBorder(new EmptyBorder(5, 5, 5, 5));
        contentPanel.setLayout(new BorderLayout(0, 0));
        setContentPane(contentPanel);

        JLabel lblSmartClientLogo = new JLabel("");
        lblSmartClientLogo.setIcon(new ImageIcon(PatchOriginal.class.getResource("/img/splash.gif")));
        contentPanel.add(lblSmartClientLogo, "Center");

        progressBar = new JProgressBar();
        progressBar.setValue(3);
        progressBar.setStringPainted(true);
        progressBar.setOpaque(true);
        progressBar.setPreferredSize(new Dimension(146, 30));
        contentPanel.add(progressBar, "South");
        setLocationRelativeTo(null);
        pack();
    }


}

package com.smartsahay.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {

    private static String url;
    private static String user;
    private static String password;

    static {
        try {
            // Register MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 1. Try reading from Cloud Environment Variables (for Render / Docker)
            url = System.getenv("DB_URL");
            user = System.getenv("DB_USER");
            password = System.getenv("DB_PASSWORD");

            // 2. Fallback to local db.properties if environment variables are not set (for Localhost / IntelliJ)
            if (url == null || url.isBlank()) {
                Properties props = new Properties();
                try (InputStream in = DBConnection.class.getClassLoader()
                        .getResourceAsStream("db.properties")) {
                    if (in != null) {
                        props.load(in);
                        url = props.getProperty("db.url");
                        user = props.getProperty("db.user");
                        password = props.getProperty("db.password");
                    } else {
                        throw new IllegalStateException(
                                "Database configuration missing: Neither environment variables (DB_URL, DB_USER, DB_PASSWORD) nor db.properties were found.");
                    }
                }
            }
        } catch (ClassNotFoundException | IOException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    private DBConnection() { }

    public static Connection getConnection() throws SQLException {
        if (url == null || url.isBlank()) {
            throw new SQLException("Database connection URL is not configured.");
        }
        return DriverManager.getConnection(url, user, password);
    }
}
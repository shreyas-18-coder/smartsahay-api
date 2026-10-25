package com.smartsahay.service;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ConcurrentHashMap;

public final class AuthService {

    public static final long TOKEN_TTL_SECONDS = 2 * 60 * 60;

    private static final Map<String, Long> TOKENS = new ConcurrentHashMap<>();
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final String ADMIN_USER;
    private static final String ADMIN_PASSWORD;

    static {
        Properties props = new Properties();
        try (InputStream in = AuthService.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in == null) {
                throw new IllegalStateException("db.properties not found in src/main/resources");
            }
            props.load(in);
        } catch (IOException e) {
            throw new ExceptionInInitializerError(e);
        }
        ADMIN_USER = props.getProperty("admin.username");
        ADMIN_PASSWORD = props.getProperty("admin.password");
        if (ADMIN_USER == null || ADMIN_USER.isBlank() || ADMIN_PASSWORD == null || ADMIN_PASSWORD.isBlank()) {
            throw new IllegalStateException("admin.username and admin.password must be set in db.properties");
        }
    }

    private AuthService() { }

    public static String login(String username, String password) {
        if (username == null || password == null) {
            return null;
        }
        boolean userOk = sameText(username, ADMIN_USER);
        boolean passOk = sameText(password, ADMIN_PASSWORD);
        if (!(userOk & passOk)) {
            return null;
        }

        long now = System.currentTimeMillis();
        TOKENS.values().removeIf(expiresAt -> expiresAt < now);

        byte[] bytes = new byte[32];
        RANDOM.nextBytes(bytes);
        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
        TOKENS.put(token, now + TOKEN_TTL_SECONDS * 1000);
        return token;
    }

    public static boolean isValid(String token) {
        if (token == null) {
            return false;
        }
        Long expiresAt = TOKENS.get(token);
        if (expiresAt == null) {
            return false;
        }
        if (System.currentTimeMillis() > expiresAt) {
            TOKENS.remove(token);
            return false;
        }
        return true;
    }

    private static boolean sameText(String a, String b) {
        return MessageDigest.isEqual(a.getBytes(StandardCharsets.UTF_8), b.getBytes(StandardCharsets.UTF_8));
    }
}
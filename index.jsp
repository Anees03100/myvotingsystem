<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VoteSecure - Secure Democratic Platform</title>
    <link href="styles/main.css" rel="stylesheet">
    <link href="https://resource.trickle.so/vendor_lib/unpkg/lucide-static@0.516.0/font/lucide.css" rel="stylesheet">
</head>
<body>
    <%
        // Database Connection parameters for WAMP
        String url = "jdbc:mysql://localhost:3306/voting_db";
        String dbUser = "root"; // Default WAMP user
        String dbPass = "";     // Default WAMP password is empty
        
        int voterCount = 0;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, dbUser, dbPass);
            
            // Fetch live count from SQL Server
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM voters");
            if(rs.next()) {
                voterCount = rs.getInt(1);
            }
            conn.close();
        } catch (Exception e) {
            // Log error or handle connection failure
        }
    %>

    <nav class="navbar">
        <div class="container">
            <a href="index.jsp" class="logo">
                <div class="logo-icon"><i class="icon-vote"></i></div>
                <span>VoteSecure</span>
            </a>
            <div class="nav-links">
                <a href="index.jsp">Home</a>
                <a href="about.jsp">About</a>
                <a href="faq.jsp">FAQ</a>
                <a href="contact.jsp">Contact</a>
            </div>
        </div>
    </nav>

    <main class="hero">
        <div class="hero-content">
            <div class="hero-icon"><i class="icon-vote"></i></div>
            <h1 class="hero-title">Online Voting System</h1>
            <p class="hero-text">
                A secure, transparent, and modern platform for democratic elections. 
                Cast your vote with confidence and make your voice heard.
            </p>
            <div class="hero-buttons">
                <a href="login-voter.jsp" class="btn btn-primary">
                    <i class="icon-user"></i> Login as Voter
                </a>
                <a href="login-admin.jsp" class="btn btn-secondary">
                    <i class="icon-shield"></i> Login as Admin
                </a>
            </div>
            <div class="hero-footer">
                Don't have an account? 
                <a href="register.jsp" class="link">Register as Voter</a>
            </div>
        </div>
    </main>

    <section class="stats-section">
        <div class="container">
            <div class="stats-grid">
                <div class="stat-box">
                    <i class="icon-users"></i>
                    <h3><%= (voterCount > 10000) ? voterCount : "10,000+" %></h3>
                    <p>Registered Voters</p>
                </div>
                <div class="stat-box">
                    <i class="icon-check-circle"></i>
                    <h3>500+</h3>
                    <p>Successful Elections</p>
                </div>
                <div class="stat-box">
                    <i class="icon-shield"></i>
                    <h3>99.9%</h3>
                    <p>Security Rating</p>
                </div>
                <div class="stat-box">
                    <i class="icon-award"></i>
                    <h3>24/7</h3>
                    <p>Support Available</p>
                </div>
            </div>
        </div>
    </section>

    <footer class="footer">
        <div class="container">
            <p>© 2025 Online Voting System. All rights reserved.</p>
            <p class="team">Developed by Team Democracy</p>
        </div>
    </footer>
</body>
</html>
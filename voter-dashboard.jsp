<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Session Security Check
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        response.sendRedirect("login-voter.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voter Dashboard - Online Voting System</title>
    <link href="styles/dashboard.css" rel="stylesheet">
    <link href="https://resource.trickle.so/vendor_lib/unpkg/lucide-static@0.516.0/font/lucide.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar">
        <div class="container">
            <div class="logo">
                <div class="logo-icon"><i class="icon-vote"></i></div>
                <span>VoteSecure</span>
            </div>
            <a href="logout.jsp" onclick="return confirm('Are you sure you want to logout?')" class="logout">Logout</a>
        </div>
    </nav>

    <main class="main-content">
        <div class="container">
            <div class="welcome-banner">
                <div class="welcome-content">
                    <%-- Display name from Session --%>
                    <h2 id="welcomeMessage">Welcome back, <%= userName %>!</h2>
                    <p>Your voice matters. Participate in active elections below.</p>
                </div>
                <div class="quick-stats">
                    <div class="quick-stat-item">
                        <i class="icon-check-circle"></i>
                        <div><strong>2</strong><span>Votes Cast</span></div>
                    </div>
                    <div class="quick-stat-item">
                        <i class="icon-clock"></i>
                        <div><strong>3</strong><span>Available</span></div>
                    </div>
                </div>
            </div>
            
            <h1 class="page-title">Available Elections</h1>
            
            <div id="electionsGrid" class="elections-grid">
                <%
                    Connection conn = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/voting_db", "root", "");
                        
                        String sql = "SELECT * FROM elections";
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(sql);

                        while (rs.next()) {
                            String title = rs.getString("title");
                            String date = rs.getString("start_date");
                            String status = rs.getString("status");
                            String badgeClass = status.equalsIgnoreCase("Active") ? "badge-active" : "badge-upcoming";
                %>
                    <div class="election-card">
                        <div class="election-header">
                            <h3><%= title %></h3>
                            <span class="badge <%= badgeClass %>"><%= status %></span>
                        </div>
                        <p class="election-date">
                            <i class="icon-calendar"></i>
                            <%= date %>
                        </p>
                        <% if(status.equalsIgnoreCase("Active")) { %>
                            <a href="vote.jsp?id=<%= rs.getInt("id") %>" class="btn-vote">Cast Vote</a>
                        <% } else { %>
                            <button class="btn-vote btn-disabled" disabled>Not Started</button>
                        <% } %>
                    </div>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<p>Error loading elections: " + e.getMessage() + "</p>");
                    } finally {
                        if (conn != null) conn.close();
                    }
                %>
            </div>
        </div>
    </main>
</body>
</html>
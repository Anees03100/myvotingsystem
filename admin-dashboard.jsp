<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Security Check: Only allow logged-in admins
    String adminUser = (String) session.getAttribute("adminUser");
    if (adminUser == null) {
        response.sendRedirect("login-admin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Online Voting System</title>
    <link href="styles/dashboard.css" rel="stylesheet">
    <link href="https://resource.trickle.so/vendor_lib/unpkg/lucide-static@0.516.0/font/lucide.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar">
        <div class="container">
            <div class="logo">
                <div class="logo-icon"><i class="icon-shield"></i></div>
                <span>VoteSecure Admin</span>
            </div>
            <a href="logout.jsp" class="logout">Logout</a>
        </div>
    </nav>

    <main class="main-content">
        <div class="container">
            <h1 class="page-title">Admin Dashboard</h1>
            <p>Logged in as: <strong><%= adminUser %></strong></p>
            
            <div class="admin-grid">
                <a href="create-election.jsp" class="admin-card">
                    <div class="admin-icon"><i class="icon-plus-circle"></i></div>
                    <h3>Create Election</h3>
                    <p>Set up a new election event</p>
                </a>

                <a href="add-candidate.jsp" class="admin-card">
                    <div class="admin-icon"><i class="icon-user-plus"></i></div>
                    <h3>Add Candidate</h3>
                    <p>Register new candidates</p>
                </a>

                <a href="results.jsp" class="admin-card">
                    <div class="admin-icon"><i class="icon-chart-bar"></i></div>
                    <h3>View Results</h3>
                    <p>Check election statistics</p>
                </a>
            </div>

            <h2 class="section-title">Created Elections</h2>
            <div class="elections-list">
                <%
                    Connection conn = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/voting_db", "root", "");
                        
                        // Fetch Elections
                        Statement stmtE = conn.createStatement();
                        ResultSet rsE = stmtE.executeQuery("SELECT * FROM elections ORDER BY id DESC");
                        
                        boolean hasElections = false;
                        while(rsE.next()) {
                            hasElections = true;
                %>
                    <div class="list-item">
                        <div class="item-header">
                            <h4><%= rsE.getString("title") %></h4>
                            <span class="item-date"><%= rsE.getString("start_date") %></span>
                        </div>
                        <p class="item-description">Status: <%= rsE.getString("status") %></p>
                    </div>
                <%
                        }
                        if(!hasElections) {
                            out.println("<p class='no-data'>No elections created yet.</p>");
                        }

                        // Fetch Candidates (Joining with elections table to show election title)
                        out.println("<h2 class='section-title'>Added Candidates</h2>");
                        Statement stmtC = conn.createStatement();
                        ResultSet rsC = stmtC.executeQuery("SELECT c.*, e.title FROM candidates c JOIN elections e ON c.election_id = e.id ORDER BY c.id DESC");
                        
                        boolean hasCandidates = false;
                        while(rsC.next()) {
                            hasCandidates = true;
                %>
                    <div class="list-item">
                        <div class="item-header">
                            <h4><%= rsC.getString("name") %></h4>
                            <span class="item-badge" style="background:#e2e8f0; padding:2px 8px; border-radius:4px; font-size:0.8rem;">
                                <%= rsC.getString("party") %>
                            </span>
                        </div>
                        <p class="item-description">Election: <%= rsC.getString("title") %></p>
                    </div>
                <%
                        }
                        if(!hasCandidates) {
                            out.println("<p class='no-data'>No candidates added yet.</p>");
                        }

                    } catch (Exception e) {
                        out.println("<p>Error: " + e.getMessage() + "</p>");
                    } finally {
                        if (conn != null) conn.close();
                    }
                %>
            </div>
        </div>
    </main>
</body>
</html>
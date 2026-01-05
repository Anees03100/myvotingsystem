<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Admin Security Check
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
    <title>Election Results - Online Voting System</title>
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
            <a href="admin-dashboard.jsp" class="logout">Back</a>
        </div>
    </nav>

    <main class="main-content">
        <div class="container">
            <h1 class="page-title">Live Election Results</h1>
            
            <div class="results-container">
                <%
                    Connection conn = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/voting_db", "root", "");

                        // 1. Get Total Registered Users for Turnout calculation
                        Statement stmtUsers = conn.createStatement();
                        ResultSet rsUsers = stmtUsers.executeQuery("SELECT COUNT(*) FROM users");
                        int totalVoters = rsUsers.next() ? rsUsers.getInt(1) : 0;

                        // 2. Get Total Votes Cast
                        Statement stmtVotes = conn.createStatement();
                        ResultSet rsVotes = stmtVotes.executeQuery("SELECT COUNT(*) FROM votes");
                        int totalVotesCast = rsVotes.next() ? rsVotes.getInt(1) : 0;

                        // 3. Fetch Candidates and their Vote Counts
                        // This JOIN query connects candidates to the votes table to count records
                        String resultQuery = "SELECT c.name, c.party, COUNT(v.id) as vote_count " +
                                           "FROM candidates c " +
                                           "LEFT JOIN votes v ON c.id = v.candidate_id " +
                                           "GROUP BY c.id ORDER BY vote_count DESC";
                        
                        Statement stmtResults = conn.createStatement();
                        ResultSet rsResults = stmtResults.executeQuery(resultQuery);

                        String leaderName = "-";
                        boolean first = true;

                        if (totalVotesCast == 0) {
                            out.println("<p class='no-data'>No votes cast yet. Results will appear once voting begins.</p>");
                        } else {
                            while (rsResults.next()) {
                                String name = rsResults.getString("name");
                                int count = rsResults.getInt("vote_count");
                                int percentage = (int) Math.round(((double) count / totalVotesCast) * 100);
                                if (first) { leaderName = name; first = false; }
                %>
                    <div class="result-item">
                        <div class="result-header">
                            <span class="candidate-name"><%= name %> (<%= rsResults.getString("party") %>)</span>
                            <span class="vote-count"><%= count %> votes (<%= percentage %>%)</span>
                        </div>
                        <div class="progress-bar" style="background: #e2e8f0; border-radius: 10px; height: 10px; margin-top: 5px;">
                            <div class="progress-fill" style="width: <%= percentage %>%; background: #4f46e5; height: 100%; border-radius: 10px;"></div>
                        </div>
                    </div>
                <%
                            }
                        }

                        // Calculate Turnout
                        int turnout = (totalVoters > 0) ? (int) Math.round(((double) totalVotesCast / totalVoters) * 100) : 0;
                %>
            </div>

            <div class="stats-grid">
                <div class="stat-card">
                    <i class="icon-users"></i>
                    <h3><%= totalVotesCast %></h3>
                    <p>Total Votes Cast</p>
                </div>
                <div class="stat-card">
                    <i class="icon-trending-up"></i>
                    <h3><%= turnout %>%</h3>
                    <p>Turnout Rate</p>
                </div>
                <div class="stat-card">
                    <i class="icon-award"></i>
                    <h3><%= leaderName %></h3>
                    <p>Current Leader</p>
                </div>
            </div>

            <%
                    } catch (Exception e) {
                        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
                    } finally {
                        if (conn != null) conn.close();
                    }
                %>
        </div>
    </main>
</body>
</html>
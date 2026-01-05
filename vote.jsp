<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Security: Check if user is logged in
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        response.sendRedirect("login-voter.jsp");
        return;
    }

    // Get election ID from URL (e.g., vote.jsp?id=1)
    String electionId = request.getParameter("id");
    if (electionId == null) {
        response.sendRedirect("voter-dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cast Your Vote - Online Voting System</title>
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
            <a href="voter-dashboard.jsp" class="logout">Back to Dashboard</a>
        </div>
    </nav>

    <main class="main-content">
        <div class="container">
            <h1 class="page-title">Cast Your Vote</h1>
            <p class="page-subtitle">Select your preferred candidate for this election</p>
            
            <div class="candidates-grid">
                <%
                    Connection conn = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/voting_db", "root", "");

                        // Logic: Process the vote if submitted via POST
                        String candidateId = request.getParameter("candidate_id");
                        if (candidateId != null) {
                            // Check if user has already voted for this election
                            PreparedStatement check = conn.prepareStatement("SELECT id FROM votes WHERE voter_email = ? AND election_id = ?");
                            check.setString(1, userEmail);
                            check.setInt(2, Integer.parseInt(electionId));
                            if (check.executeQuery().next()) {
                                out.println("<script>alert('Error: You have already cast your vote for this election!');</script>");
                            } else {
                                PreparedStatement voteStmt = conn.prepareStatement("INSERT INTO votes (voter_email, candidate_id, election_id) VALUES (?, ?, ?)");
                                voteStmt.setString(1, userEmail);
                                voteStmt.setInt(2, Integer.parseInt(candidateId));
                                voteStmt.setInt(3, Integer.parseInt(electionId));
                                if (voteStmt.executeUpdate() > 0) {
                                    response.sendRedirect("vote-success.jsp");
                                }
                            }
                        }

                        // Fetch Candidates
                        PreparedStatement pst = conn.prepareStatement("SELECT * FROM candidates WHERE election_id = ?");
                        pst.setInt(1, Integer.parseInt(electionId));
                        ResultSet rs = pst.executeQuery();

                        while (rs.next()) {
                %>
                    <div class="candidate-card">
                        <div class="candidate-photo"><i class="icon-user"></i></div>
                        <h3><%= rs.getString("name") %></h3>
                        <p class="candidate-party"><%= rs.getString("party") %></p>
                        
                        <form method="POST">
                            <input type="hidden" name="candidate_id" value="<%= rs.getInt("id") %>">
                            <button type="submit" class="btn-select" 
                                    onclick="return confirm('Are you sure you want to vote for <%= rs.getString("name") %>?')">
                                Select Candidate
                            </button>
                        </form>
                    </div>
                <%
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
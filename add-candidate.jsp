<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Security: Only allow logged-in admins
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
    <title>Add Candidate - Online Voting System</title>
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
        <div class="container form-container">
            <h1 class="page-title">Add New Candidate</h1>
            
            <%
                // Handle Form Submission
                String name = request.getParameter("candidateName");
                if (name != null) {
                    String party = request.getParameter("party");
                    String electionId = request.getParameter("election");
                    String bio = request.getParameter("biography");

                    Connection conn = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/voting_db", "root", "");
                        
                        String sql = "INSERT INTO candidates (name, party, election_id, biography) VALUES (?, ?, ?, ?)";
                        PreparedStatement pst = conn.prepareStatement(sql);
                        pst.setString(1, name);
                        pst.setString(2, party);
                        pst.setInt(3, Integer.parseInt(electionId));
                        pst.setString(4, bio);
                        
                        if (pst.executeUpdate() > 0) {
                            out.println("<div class='alert-success' style='color:green; text-align:center; padding:10px;'>Candidate added successfully!</div>");
                        }
                    } catch (Exception e) {
                        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
                    } finally {
                        if (conn != null) conn.close();
                    }
                }
            %>
            
            <form class="admin-form" method="POST" action="add-candidate.jsp">
                <div class="form-group">
                    <label>Candidate Name</label>
                    <input type="text" name="candidateName" pattern="[A-Za-z ]{3,50}" required>
                </div>
                
                <div class="form-group">
                    <label>Party Affiliation</label>
                    <input type="text" name="party" pattern="[A-Za-z ]{2,50}" required>
                </div>
                
                <div class="form-group">
                    <label>Election</label>
                    <select name="election" required>
                        <option value="">Select Election</option>
                        <%
                            // Fetch elections from DB for the dropdown
                            Connection conn2 = null;
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                conn2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/voting_db", "root", "");
                                Statement stmt = conn2.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT id, title FROM elections");
                                while(rs.next()) {
                                    out.println("<option value='" + rs.getInt("id") + "'>" + rs.getString("title") + "</option>");
                                }
                            } catch (Exception e) { } finally { if (conn2 != null) conn2.close(); }
                        %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Biography</label>
                    <textarea name="biography" rows="4" minlength="20"></textarea>
                </div>
                
                <button type="submit" class="btn-submit-full">Add Candidate</button>
            </form>
        </div>
    </main>
</body>
</html>
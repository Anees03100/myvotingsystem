<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Ensure only an admin can view this page
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
    <title>Election Created - Online Voting System</title>
    <link href="styles/dashboard.css" rel="stylesheet">
    <link href="https://resource.trickle.so/vendor_lib/unpkg/lucide-static@0.516.0/font/lucide.css" rel="stylesheet">
</head>
<body>
    <div class="success-container">
        <div class="success-card">
            <div class="success-icon">
                <i class="icon-check-circle"></i>
            </div>
            <h1>Election Created Successfully!</h1>
            
            <div id="electionDetails" class="election-details">
                <%
                    Connection conn = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/voting_db", "root", "");
                        
                        // Query the most recently created election for this admin
                        String sql = "SELECT * FROM elections ORDER BY created_at DESC LIMIT 1";
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(sql);
                        
                        if (rs.next()) {
                %>
                    <p style="color: #666; margin-bottom: 1rem;">Election details:</p>
                    <div style="background: #f8f9fa; padding: 1.5rem; border-radius: 8px; text-align: left; border: 1px solid #ddd;">
                        <p style="margin-bottom: 0.5rem;"><strong>Title:</strong> <%= rs.getString("title") %></p>
                        <p style="margin-bottom: 0.5rem;"><strong>Description:</strong> <%= rs.getString("description") %></p>
                        <p style="margin-bottom: 0.5rem;"><strong>Start Date:</strong> <%= rs.getDate("start_date") %></p>
                        <p><strong>End Date:</strong> <%= rs.getDate("end_date") %></p>
                    </div>
                <%
                        } else {
                            out.println("<p>No recent election data found.</p>");
                        }
                    } catch (Exception e) {
                        out.println("<p style='color:red;'>Error fetching details: " + e.getMessage() + "</p>");
                    } finally {
                        if (conn != null) conn.close();
                    }
                %>
            </div>

            <div style="display: flex; gap: 1rem; justify-content: center; margin-top: 2rem;">
                <a href="admin-dashboard.jsp" class="btn-primary">Back to Dashboard</a>
                <a href="create-election.jsp" class="btn-secondary">Create Another</a>
            </div>
        </div>
    </div>
</body>
</html>
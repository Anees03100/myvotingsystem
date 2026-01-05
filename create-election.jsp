<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Security Check: Only admins allowed
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
    <title>Create Election - Online Voting System</title>
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
            <h1 class="page-title">Create New Election</h1>
            
            <%
                // Server-side Processing
                String title = request.getParameter("title");
                if (title != null) {
                    String description = request.getParameter("description");
                    String startDate = request.getParameter("startDate");
                    String endDate = request.getParameter("endDate");

                    Connection conn = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/voting_db", "root", "");
                        
                        String sql = "INSERT INTO elections (title, description, start_date, end_date) VALUES (?, ?, ?, ?)";
                        PreparedStatement pst = conn.prepareStatement(sql);
                        pst.setString(1, title);
                        pst.setString(2, description);
                        pst.setString(3, startDate);
                        pst.setString(4, endDate);
                        
                        int result = pst.executeUpdate();
                        if (result > 0) {
                            out.println("<p style='color:green; text-align:center;'>Election Created Successfully! <a href='admin-dashboard.jsp'>View Dashboard</a></p>");
                        }
                    } catch (Exception e) {
                        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
                    } finally {
                        if (conn != null) conn.close();
                    }
                }
            %>
            
            <form class="admin-form" method="POST" action="create-election.jsp" onsubmit="return validateDates()">
                <div class="form-group">
                    <label>Election Title</label>
                    <input type="text" name="title" pattern="[A-Za-z ]{5,50}" required>
                    <small class="input-hint">Only letters and spaces (5-50 characters)</small>
                </div>
                
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" rows="4" minlength="10" maxlength="200" required></textarea>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Start Date</label>
                        <input type="date" id="startDate" name="startDate" required>
                    </div>
                    
                    <div class="form-group">
                        <label>End Date</label>
                        <input type="date" id="endDate" name="endDate" required>
                    </div>
                </div>
                
                <button type="submit" class="btn-submit-full">Create Election</button>
            </form>
        </div>
    </main>

    <script>
        function validateDates() {
            var start = new Date(document.getElementById('startDate').value);
            var end = new Date(document.getElementById('endDate').value);
            var today = new Date();
            today.setHours(0,0,0,0);

            if (start < today) {
                alert("Start date cannot be in the past.");
                return false;
            }
            if (end <= start) {
                alert("End date must be after the start date.");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
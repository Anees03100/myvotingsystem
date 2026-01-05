<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - Online Voting System</title>
    <link href="styles/auth.css" rel="stylesheet">
    <link href="https://resource.trickle.so/vendor_lib/unpkg/lucide-static@0.516.0/font/lucide.css" rel="stylesheet">
</head>
<body>
    <div class="auth-container">
        <div class="auth-card">
            <a href="index.html" class="auth-logo">
                <div class="auth-logo-icon">
                    <i class="icon-shield"></i>
                </div>
            </a>
            <h2 class="auth-title">Admin Login</h2>
            <p class="auth-subtitle">Secure administrative access</p>
            
            <%
                String user = request.getParameter("username");
                String pass = request.getParameter("password");

                if (user != null && pass != null) {
                    Connection conn = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/voting_db", "root", "");
                        
                        String sql = "SELECT * FROM admins WHERE username = ? AND password = ?";
                        PreparedStatement pst = conn.prepareStatement(sql);
                        pst.setString(1, user);
                        pst.setString(2, pass);
                        
                        ResultSet rs = pst.executeQuery();
                        if (rs.next()) {
                            // Set unique session attribute for Admin to prevent unauthorized access to voter pages
                            session.setAttribute("adminUser", rs.getString("username"));
                            session.setAttribute("role", "ADMIN");
                            response.sendRedirect("admin-dashboard.jsp");
                        } else {
                            out.println("<p style='color:red; text-align:center;'>Invalid admin credentials!</p>");
                        }
                    } catch (Exception e) {
                        out.println("<p style='color:red; text-align:center;'>Database Error: " + e.getMessage() + "</p>");
                    } finally {
                        if (conn != null) conn.close();
                    }
                }
            %>
            
            <form class="auth-form" method="POST" action="login-admin.jsp">
                <div class="form-group">
                    <label>Admin Username</label>
                    <input type="text" name="username" placeholder="Enter admin username" required>
                </div>
                
                <div class="form-group">
                    <label>Admin Password</label>
                    <input type="password" name="password" placeholder="Enter admin password" required>
                </div>
                
                <button type="submit" class="btn-submit">Login as Admin</button>
            </form>
            
            <div class="auth-footer">
                <a href="index.html" class="back-link">← Back to Home</a>
            </div>
        </div>
    </div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voter Login</title>
    <link href="styles/auth.css" rel="stylesheet">
</head>
<body>
    <div class="auth-container">
        <div class="auth-card">
            <h2 class="auth-title">Voter Login</h2>
            
            <%
                String email = request.getParameter("email");
                String password = request.getParameter("password");

                if (email != null && password != null) {
                    Connection conn = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/voting_db", "root", "");
                        
                        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
                        PreparedStatement pst = conn.prepareStatement(sql);
                        pst.setString(1, email);
                        pst.setString(2, password);
                        
                        ResultSet rs = pst.executeQuery();
                        if (rs.next()) {
                            // Store user info in Session instead of LocalStorage
                            session.setAttribute("userName", rs.getString("full_name"));
                            session.setAttribute("userEmail", rs.getString("email"));
                            response.sendRedirect("voter-dashboard.jsp");
                        } else {
                            out.println("<p style='color:red; text-align:center;'>Invalid email or password!</p>");
                        }
                    } catch (Exception e) {
                        out.println("<p style='color:red;'>Database Error: " + e.getMessage() + "</p>");
                    } finally {
                        if (conn != null) conn.close();
                    }
                }
            %>

            <form class="auth-form" method="POST" action="login-voter.jsp">
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" required>
                </div>
                <button type="submit" class="btn-submit">Login</button>
            </form>
            <div class="auth-footer">
                <p>Don't have an account? <a href="register.jsp">Register here</a></p>
            </div>
        </div>
    </div>
</body>
</html>
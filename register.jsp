<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voter Registration - Online Voting System</title>
    <link href="styles/auth.css" rel="stylesheet">
    <style>
        .password-strength { font-size: 0.85rem; margin-top: 5px; font-weight: bold; }
        .weak { color: #dc3545; }
        .medium { color: #ffc107; }
        .strong { color: #28a745; }
        .input-hint { display: block; font-size: 0.75rem; color: #666; margin-top: 3px; }
        .error-msg { color: #dc3545; text-align: center; margin-bottom: 15px; font-weight: bold; }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="auth-card register-card">
            <h2 class="auth-title">Voter Registration</h2>
            
            <%
                String fullName = request.getParameter("fullName");
                if (fullName != null) {
                    String email = request.getParameter("email");
                    String cnic = request.getParameter("cnic");
                    String ageStr = request.getParameter("age");
                    String password = request.getParameter("password");
                    String confirmPassword = request.getParameter("confirmPassword");

                    // Server-side Name Validation (Only letters and spaces)
                    if (!fullName.matches("^[A-Za-z\\s]+$")) {
                        out.println("<div class='error-msg'>Invalid Name: Use only letters and spaces!</div>");
                    } 
                    // Confirm Password Validation
                    else if (!password.equals(confirmPassword)) {
                        out.println("<div class='error-msg'>Passwords do not match!</div>");
                    } else {
                        Connection conn = null;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/voting_db", "root", "");
                            
                            // Check for existing email
                            String checkSql = "SELECT id FROM users WHERE email = ?";
                            PreparedStatement checkPst = conn.prepareStatement(checkSql);
                            checkPst.setString(1, email);
                            ResultSet rs = checkPst.executeQuery();
                            
                            if (rs.next()) {
                                out.println("<div class='error-msg'>Email already exists!</div>");
                            } else {
                                String sql = "INSERT INTO users (full_name, email, cnic, age, password) VALUES (?, ?, ?, ?, ?)";
                                PreparedStatement pst = conn.prepareStatement(sql);
                                pst.setString(1, fullName);
                                pst.setString(2, email);
                                pst.setString(3, cnic);
                                pst.setInt(4, Integer.parseInt(ageStr));
                                pst.setString(5, password); 
                                
                                if (pst.executeUpdate() > 0) {
                                    response.sendRedirect("login-voter.jsp?registration=success");
                                }
                            }
                        } catch (Exception e) {
                            out.println("<p class='error-msg'>Error: " + e.getMessage() + "</p>");
                        } finally {
                            if (conn != null) conn.close();
                        }
                    }
                }
            %>

            <form class="auth-form" method="POST" action="register.jsp">
                <div class="form-grid">
                    <div class="form-group">
                        <label>Full Name</label>
                        <%-- Pattern attribute enforces letter-only on the client side --%>
                        <input type="text" name="fullName" placeholder="Enter your full name" 
                               pattern="[A-Za-z\s]+" title="Only letters and spaces allowed" required>
                        <small class="input-hint">Only letters and spaces allowed</small>
                    </div>
                    
                    <div class="form-group">
                        <label>Email Address</label>
                        <input type="email" name="email" required>
                    </div>
                    
                    <div class="form-group">
                        <label>CNIC Number</label>
                        <input type="text" name="cnic" placeholder="xxxxx-xxxxxxx-x" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Age</label>
                        <input type="number" name="age" min="18" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" id="password" name="password" 
                               oninput="checkPasswordStrength()" required>
                        <div id="passwordStrength" class="password-strength"></div>
                    </div>
                    
                    <div class="form-group">
                        <label>Confirm Password</label>
                        <input type="password" name="confirmPassword" required>
                    </div>
                </div>
                
                <button type="submit" class="btn-submit">Register</button>
            </form>
            
            <div class="auth-footer">
                <p>Already have an account? <a href="login-voter.jsp">Login here</a></p>
            </div>
        </div>
    </div>

    <script>
        function checkPasswordStrength() {
            var password = document.getElementById('password').value;
            var strengthDiv = document.getElementById('passwordStrength');
            if (password.length === 0) { strengthDiv.textContent = ''; return; }
            
            var strength = 0;
            if (password.length >= 8) strength++;
            if (/[a-zA-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^a-zA-Z0-9]/.test(password)) strength++;
            
            if (strength <= 2) {
                strengthDiv.textContent = 'Weak Password';
                strengthDiv.className = 'password-strength weak';
            } else if (strength === 3) {
                strengthDiv.textContent = 'Medium Password';
                strengthDiv.className = 'password-strength medium';
            } else {
                strengthDiv.textContent = 'Strong Password';
                strengthDiv.className = 'password-strength strong';
            }
        }
    </script>
</body>
</html>
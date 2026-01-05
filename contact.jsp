<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Contact Us - Online Voting System</title>
    <link href="styles/pages.css" rel="stylesheet">
    <link href="https://resource.trickle.so/vendor_lib/unpkg/lucide-static@0.516.0/font/lucide.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar">
        <div class="container">
            <a href="index.html" class="logo">
                <div class="logo-icon"><i class="icon-vote"></i></div>
                <span>VoteSecure</span>
            </a>
            <div class="nav-links">
                <a href="index.html">Home</a>
                <a href="about.html">About</a>
                <a href="faq.html">FAQ</a>
                <a href="contact.jsp">Contact</a>
            </div>
        </div>
    </nav>

    <main class="page-content">
        <div class="container">
            <h1 class="page-title">Contact Us</h1>
            
            <%-- Server-side message processing --%>
            <%
                String name = request.getParameter("name");
                if (name != null) {
                    String email = request.getParameter("email");
                    String subject = request.getParameter("subject");
                    String message = request.getParameter("message");

                    Connection conn = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/voting_db", "root", "");
                        
                        String sql = "INSERT INTO contact_messages (name, email, subject, message) VALUES (?, ?, ?, ?)";
                        PreparedStatement pst = conn.prepareStatement(sql);
                        pst.setString(1, name);
                        pst.setString(2, email);
                        pst.setString(3, subject);
                        pst.setString(4, message);
                        
                        if (pst.executeUpdate() > 0) {
                            out.println("<p style='color:green; text-align:center; font-weight:bold;'>Message sent successfully!</p>");
                        }
                    } catch (Exception e) {
                        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
                    } finally {
                        if (conn != null) conn.close();
                    }
                }
            %>

            <div class="contact-container">
                <div class="contact-info">
                    <div class="info-card"><i class="icon-mail"></i><h3>Email</h3><p>support@votesecure.com</p></div>
                    <div class="info-card"><i class="icon-phone"></i><h3>Phone</h3><p>+1 (555) 123-4567</p></div>
                    <div class="info-card"><i class="icon-map-pin"></i><h3>Address</h3><p>123 Democracy Street</p></div>
                </div>

                <form class="contact-form" method="POST" action="contact.jsp">
                    <h2>Send Us a Message</h2>
                    <div class="form-group"><label>Full Name</label><input type="text" name="name" required></div>
                    <div class="form-group"><label>Email Address</label><input type="email" name="email" required></div>
                    <div class="form-group"><label>Subject</label><input type="text" name="subject" required></div>
                    <div class="form-group"><label>Message</label><textarea name="message" rows="5" required></textarea></div>
                    <button type="submit" class="btn-submit">Send Message</button>
                </form>
            </div>
        </div>
    </main>
</body>
</html>
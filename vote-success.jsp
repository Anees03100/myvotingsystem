<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Security: Check if user is logged in before showing success page
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        response.sendRedirect("login-voter.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vote Submitted - Online Voting System</title>
    <link href="styles/dashboard.css" rel="stylesheet">
    <link href="https://resource.trickle.so/vendor_lib/unpkg/lucide-static@0.516.0/font/lucide.css" rel="stylesheet">
    <style>
        /* Ensuring the success card is centered nicely */
        .success-container {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 80vh;
            padding: 20px;
        }
        .success-card {
            text-align: center;
            background: black;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            max-width: 500px;
            width: 100%;
        }
        .success-icon {
            font-size: 64px;
            color: #28a745;
            margin-bottom: 20px;
        }
        .btn-primary {
            display: inline-block;
            margin-top: 25px;
            padding: 12px 24px;
            background-color: #007bff;
            color: black;
            text-decoration: none;
            border-radius: 6px;
            transition: background 0.3s;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="success-card">
            <div class="success-icon">
                <i class="icon-check-circle"></i>
            </div>
            <h1>Vote Submitted Successfully!</h1>
            <p>Thank you, <strong><%= userName %></strong>, for participating in the democratic process.</p>
            <p>Your vote has been recorded securely in our database.</p>
            
            <a href="voter-dashboard.jsp" class="btn-primary">Back to Dashboard</a>
        </div>
    </div>
</body>
</html>
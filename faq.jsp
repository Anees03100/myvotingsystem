<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FAQ - Online Voting System</title>
    <link href="styles/pages.css" rel="stylesheet">
    <link href="https://resource.trickle.so/vendor_lib/unpkg/lucide-static@0.516.0/font/lucide.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar">
        <div class="container">
            <a href="index.jsp" class="logo">
                <div class="logo-icon"><i class="icon-vote"></i></div>
                <span>VoteSecure</span>
            </a>
            <div class="nav-links">
                <a href="index.jsp">Home</a>
                <a href="about.jsp">About</a>
                <a href="faq.jsp">FAQ</a>
                <a href="contact.jsp">Contact</a>
            </div>
        </div>
    </nav>

    <main class="page-content">
        <div class="container">
            <h1 class="page-title">Frequently Asked Questions</h1>
            <p class="page-subtitle">Find answers to common questions</p>
            
            <div class="faq-container">
                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <h3>How do I register to vote?</h3>
                        <i class="icon-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Click on "Register as Voter" on the homepage and provide your full name, email, CNIC, and age. You must be at least 18 to participate.</p>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <h3>Is my vote secure and anonymous?</h3>
                        <i class="icon-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Yes. Your vote is recorded securely in our WAMP SQL database and is never linked directly to your identity for total anonymity.</p>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <h3>Can I change my vote after submitting?</h3>
                        <i class="icon-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>No. To maintain election integrity, once a vote is cast in our database, it cannot be edited or deleted.</p>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <h3>What if I forget my password?</h3>
                        <i class="icon-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Contact support@votesecure.com from your registered email to initiate a secure reset process.</p>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <footer class="footer">
        <div class="container">
            <p>© 2026 Online Voting System. All rights reserved.</p>
        </div>
    </footer>

    <script>
        function toggleFAQ(element) {
            var faqItem = element.parentElement;
            var isActive = faqItem.classList.contains('active');
            document.querySelectorAll('.faq-item').forEach(function(item) {
                item.classList.remove('active');
            });
            if (!isActive) faqItem.classList.add('active');
        }
    </script>
</body>
</html>
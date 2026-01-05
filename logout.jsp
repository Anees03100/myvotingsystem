<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    session.invalidate(); // Destroy the user session
    response.sendRedirect("index.html"); // Go back to home
%>
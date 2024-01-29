<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date, java.text.SimpleDateFormat, java.io.OutputStream, java.util.Base64"%>
<%@ page import="java.sql.*"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<!DOCTYPE html>
<html>
<head>
    <title>Welcome Page</title>
    <style>
        /* Set the maximum width and height for the image */
        img {
            max-width: 100px;
            max-height: 100px;
        }
    </style>
</head>
<body>
    <%
        HttpSession session1 = request.getSession(false);

        // Check if the user is logged in
        if (session1 != null && session1.getAttribute("username") != null) {
            String username = (String) session1.getAttribute("username");
            Object logintime = session1.getAttribute("loginTime");

            // Format the login time using SimpleDateFormat
            //SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            //String formattedLoginTime = sdf.format(logintime);
            Blob image;
            byte[] imgData;
            String base64Image = null;
            
		
        try
        {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/jsp", "root", "stranger");
            PreparedStatement stmt = con.prepareStatement("select photo from log where username = ?");
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if(rs.next())
            {
            	image = rs.getBlob(1);
                imgData = image.getBytes(1,(int)image.length());
                //response.setContentType("image/jpg");
                //OutputStream o = response.getOutputStream();
                //o.write(imgData);
                //o.flush();
                //o.close();
                base64Image = Base64.getEncoder().encodeToString(imgData);
            }
            else
            {
            	System.out.println("image cannot be retrieved");
            }
                String query = "UPDATE user_sessions SET logout_time = ? WHERE username = ?";
                try (PreparedStatement pst = con.prepareStatement(query)) {
                    pst.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
                    pst.setString(2, username);
                    pst.executeUpdate();
                    System.out.println("Logout"+new Timestamp(System.currentTimeMillis()));
                    
                }

                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            // Display user information
    %>
            <h2>Welcome, <%= username %></h2>
            <p>login_time: <%= logintime %></p>
            <img src="data:image/jpeg;base64, <%= base64Image %>" alt="Image" width="100" height="100">
            <!-- Add your content for the welcome page here -->
            <a href="logout.jsp">Logout</a>
    <%
        } else {
            // Redirect to login page if the user is not logged in
            response.sendRedirect("login.jsp"); // Change to the appropriate page
        }
    %>
</body>
</html>

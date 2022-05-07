<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Login Page</title>
<style>


submit {
background-color: lightblue;
color: black;
font-size: 25px;

text-align : center;
}

div {
  margin-bottom: 15px;
  padding: 4px 12px;
}

.info {
  background-color: #e7f3fe;
  border-left: 6px solid #2196F3;
}

#al {
    text-align: center;
}
#username {
    width: 200px;
}
#password {
    width: 200px;
}

</style>
</head>
<body>

<div class="info">
  <p><strong>Info! </strong> </p>
  <p> Run this from your mongodb shell</p>
  <p> use(sample_restaurants)</p>
  <p> db.users.insertOne({username : "admin", password : "password"}) </p>
</div>
<div id="al">
<form action="admin.jsp">
			<p style="color: black">
				Username: <input type="text" name="username" id="username"><br><br>
				Password: <input type="password" id="password" name="password" minlength="8" required><br>
			   <br><input type="submit" id="submit">
</div>

</form>

</body>
</html>
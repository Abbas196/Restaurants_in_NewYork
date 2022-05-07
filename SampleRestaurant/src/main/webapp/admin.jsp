<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<%@page import="com.mongodb.MongoClient"%>
<%@page import="com.mongodb.DB"%>
<%@page import="com.mongodb.client.MongoCollection"%>
<%@page import="com.mongodb.client.MongoDatabase"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.io.*"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="org.bson.Document"%>
<%@page import="com.mongodb.DBCollection"%>
<%@page import="com.mongodb.client.model.InsertOneModel"%>
<%@page import="com.mongodb.client.model.BulkWriteOptions"%>
<%@page import="com.mongodb.BasicDBObject"%>
<%@page import="com.mongodb.client.FindIterable"%>

<html>
<head>

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<meta charset="ISO-8859-1">
<title>Admin operations</title>
<style>
.info {
	background-color: #e7f3fe;
	border-left: 6px solid #2196F3;
}

.insert {
	background-color: #ffdddd;
	border-left: 6px solid #f44336;
}

.update {
	background-color: #ddffdd;
	border-left: 6px solid #04AA6D;
}

.delete {
	background-color: #ffffcc;
	border-left: 6px solid #ffeb3b;
}

#design {
	text-align: center;
}
</style>
</head>
<body>

	<%
	MongoClient mongoClient = new MongoClient("localhost", 27017);
	System.out.println("MongoDB connected......");

	MongoDatabase db = mongoClient.getDatabase("sample_restaurants");
	System.out.println("Database connected......");

	MongoCollection<Document> users = db.getCollection("users");
	System.out.println("Users Collection connected ......");

	String username = request.getParameter("username");
	String password = request.getParameter("password");
    
	
	session.setAttribute("username",username);
	session.setAttribute("password",password);
	
	
	List obj = new ArrayList();
	obj.add(new BasicDBObject("username", username));
	obj.add(new BasicDBObject("password", password));
	BasicDBObject whereQuery = new BasicDBObject();
	whereQuery.put("$and", obj);
	boolean check = find_user(whereQuery, users, username, password);
	if (check == true) {
	%>

	<div class="info">
		<p>
			<strong>Info! </strong> Create a folder "C:\documents" and place the
			file to be inserted in this location
		</p>
	</div>

	<div class="insert">
		<p>
			<strong>Insert! </strong> To insert a document, create a json file in
			required format, place it in "C:\documents" folder, select the
			collection from the dropdown and submit
		</p>
	</div>

	<div class="delete">
		<p>
			<strong>Delete! </strong> To delete a document, Enter the id, select the collection from the dropdown and
			press delete button
		</p>
	</div>

	<div class="update">
		<p>
			<strong>Update! </strong> To update an existing document delete it
			and insert it
		</p>
	</div>
	<div id="design">
		<form action="admin_task.jsp">
			<br>
			<br>
			<h1>Please select the Operation:</h1>
			  <input type="radio" id="myradio" name="type" value="Insert">Insert
			  <input type="radio" id="myradio" name="type" value="Delete">Delete
			  <br>
			<br>
			<div id="textboxes" style="display: none">
				<label for="collection"> Collection Name : </label> <select
					name="collection" id="collection">
					<option value="Neighborhoods">Neighborhoods</option>
					<option value="Restaurants">Restaurants</option>
				</select>

				
					<br>
					<br>
					</t>
					<label for="myfile">Browse: </label> <input type="file" id="myfile"
						name="myfile"><br>
					<br>

				<input type="submit" style="height: 30px" id="submit" value="Insert">
			</div>



			<div id="delete" style="display: none">
			<br>
				Enter ID:  <input type="id" name="id"
					id="id" style="width: 100px; height: 20px; fornt-size: 20px;">
					<br><br>
				<label for="collection"> Collection Name : </label> <select
					name="collection" id="collection">
					<option value="Neighborhoods">Neighborhoods</option>
					<option value="Restaurants">Restaurants</option>
				</select>
<br><br>
				<input type="submit" style="height: 30px" id="submit" value="Delete">
			</div>
		</form>
			
	</div>
	
<%
	}
	else {
	%>

	<h1>Incorrect Username/Password or User not found!!</h1>


	<%
	}
	%>
	
</body>

<script>
	$(function() {
		$('input[name="type"]').on('click', function() {
			if ($(this).val() == 'Insert') {
				$('#textboxes').show();
				$('#delete').hide();
			}

			if ($(this).val() == 'Delete') {
				$('#delete').show();
				$('#textboxes').hide();
			}

		});
	});
</script>

<%!public boolean find_user(BasicDBObject whereQuery, MongoCollection<Document> users, String username,
			String password) {
		FindIterable<Document> cursor = users.find(whereQuery);
		Document result = cursor.first();

		String s = null;
		if (result == null) {
			return false;
		}

		else {
			for (Document doc : cursor) {
				if (doc.getString("username").equals(username) && doc.getString("password").equals(password)) {
					System.out.println("user found");
				} // if(!doc.getString("name").equals(""))
			} //for(Document doc : cursor)

			return true;
		}
	}%>

</html>
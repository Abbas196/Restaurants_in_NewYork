<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<%@page import="com.mongodb.MongoClient"%>
<%@page import="com.mongodb.BasicDBObject"%>
<%@page import="com.mongodb.client.MongoCollection"%>
<%@page import="com.mongodb.client.MongoCursor"%>
<%@page import="com.mongodb.client.MongoDatabase"%>
<%@page import="org.bson.Document"%>
<%@page import="com.mongodb.client.FindIterable"%>
<%@page import="com.mongodb.client.DistinctIterable"%>
<%@page import="java.util.ArrayList"%>
<html>
<head>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<link rel="stylesheet"
	href="//code.jquery.com/ui/1.13.1/themes/base/jquery-ui.css">
<link rel="stylesheet" href="/resources/demos/style.css">
<script src="https://code.jquery.com/jquery-3.6.0.js"></script>
<script src="https://code.jquery.com/ui/1.13.1/jquery-ui.js"></script>
<link href="https://fonts.googleapis.com/css2?family=Lato:wght@300;400;700&display=swap" rel="stylesheet">

<meta charset="ISO-8859-1">
<title>MongoDB Restaurant APP</title>
<style>
* {
font-family: 'Lato', sans-serif;
}

label {
font-weight: 600;
margin-bottom: 4px;
display: block;
}


.form-center {
    display: flex;
    justify-content: center;
    margin-top: 48px;

 

}

form {
background-color: white;
padding: 3rem;
    border-radius: 12px;
      box-shadow: 0 14px 28px rgba(0,0,0,0.25), 0 10px 10px rgba(0,0,0,0.22);
   //   box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
  transition: all 0.3s cubic-bezier(.25,.8,.25,1);
 
}

.submit {
width: 148px;
height: 32px;
display: flex;
align-items: center;
justify-content: center;
cursor: pointer;
}

body {
    background-size: 100%;
    background-repeat: no-repeat;
    background-position: center;
    background-image: url('https://images.unsplash.com/photo-1633040243823-6bf8d4edb0ec?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80');
}

.overlay {
position: fixed;
}


</style>
</head>

<body>
	<%
	MongoClient mongoClient = new MongoClient("localhost", 27017);
	System.out.println("MongoDB connected......");

	MongoDatabase db = mongoClient.getDatabase("sample_restaurants");
	System.out.println("Database connected......");

	MongoCollection<Document> neighborhoods = db.getCollection("neighborhoods");
	System.out.println("neighborhoods Collection connected ......");

	MongoCollection<Document> restaurants = db.getCollection("restaurants");
	System.out.println("restaurants Collection connected ......");
	%>
	<div class="overlay"></div>
	<div class="form-center">

		<form action="Search_result.jsp">
			<p style="color: black">
			<label>Restaurant Name:</label>
				 <input placeholder="Restaurant Name" type="text" name="keyword"
					id="keyword" style="width: 360px; height: 40px; fornt-size: 20px;">

				<br>
				<br> <label for="borough">Borough:</label> <select
					name="borough" id="borough">
					<option value="default"></option>


					<%
					DistinctIterable<String> iter2 = restaurants.distinct("borough", String.class);
					MongoCursor<String> cursor2 = iter2.iterator();

					ArrayList<String> list = new ArrayList<String>();
					while (cursor2.hasNext()) {

						list.add(cursor2.next());
					}

					String Field;
					for (int i = 0; i < list.size(); i++) {
						Field = list.get(i).toString();
						if (!Field.equals("Missing")) {
					%>
					<option value="<%=Field%>"><%=Field%></option>
					<%
					} //if(!Field.equals("Missing"))
					} //while (cursor2.hasNext())
					%>
				</select> 
				<br>
				<br>
				 <label for="neighborhoods">Neighborhoods:</label> <select
					name="neighborhoods" id="neighborhoods">
					<option value="default"></option>


					<%
					BasicDBObject query_neighborhood_name = new BasicDBObject();
					FindIterable<Document> iter1 = neighborhoods.find(query_neighborhood_name).sort(new BasicDBObject("name", 1));

					MongoCursor<Document> cursor1 = iter1.iterator();

					Document result1 = null;

					while (cursor1.hasNext()) {
						result1 = (Document) cursor1.next();
					%>
					
					<option value="<%=result1.getString("name")%>"><%=result1.getString("name")%></option>

					<%
					} //while(cursor1.hasNext())
					%>
				</select> <br>
				
				<br> 
				<label for="distance">Distance:</label> <select
					name="distance" id="distance">
					
					<option value="0.5">0.5 Mile</option>
					<option value="1">1 Mile</option>
					<option value="2">2 Miles</option>
					<option value="5">5 Miles</option>
					<option value="10">10 Miles</option>
					

				</select> 
				<br>
				<br> 
				<label for="cuisine">Cuisine:</label> <select
					name="cuisine" id="cuisine">
					<option value="default"></option>

					<%
					DistinctIterable<String> iter3 = restaurants.distinct("cuisine", String.class);
					MongoCursor<String> cursor3 = iter3.iterator();

					ArrayList<String> list1 = new ArrayList<String>();
					while (cursor3.hasNext()) {

						list1.add(cursor3.next());
					}

					String Field1;
					for (int i = 0; i < list1.size(); i++) {
						Field1 = list1.get(i).toString();
						if (!Field1.equals("Missing")) {
					%>
					
					<option value="<%=Field1%>"><%=Field1%></option>
					
					<%
					} //if(!Field1.equals("Missing"))
					} //while (cursor3.hasNext())
					%>
				</select> 
				<br>
				<br> 
				<input type="submit" class="submit"  id="submit">
		</form>
</body>

</div>

<script>
	document.getElementById("borough")
			.addEventListener("click", disblefunction);

	function disblefunction() {
		if ($('#borough').val() != "default") {
			$('#neighborhoods').prop('disabled', true);
			$('#distance').prop('disabled', true);
		} else {
			$('#neighborhoods').prop('disabled', false);
			$('#distance').prop('disabled', false);
		}
	}
</script>

<script>
	document.getElementById("neighborhoods").addEventListener("click",
			disblefunction);

	function disblefunction() {
		if ($('#neighborhoods').val() != "default") {
			$('#borough').prop('disabled', true);

		} else {
			$('#borough').prop('disabled', false);
			$('#distance').prop('disabled', false);
		}
	}
</script>
<script>
	document.getElementById("submit").addEventListener("click", disblefunction);

	function disblefunction() {
		if ($('#neighborhoods').val() == "default"
				&& $('#borough').val() == "default"
				&& $('#keyword').val() == ""
				&& $('#cuisine').val() == "default") {
			$('#submit').prop('disabled', true);
			alert("Please Provide some input");

		}
		location.reload();
	}
</script>


</html>
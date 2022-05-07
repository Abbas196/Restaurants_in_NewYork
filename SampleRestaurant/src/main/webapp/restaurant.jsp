<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import = "com.mongodb.MongoClient" %>
<%@page import = "com.mongodb.BasicDBObject" %>
<%@page import = "com.mongodb.BasicDBList" %>
<%@page import = "com.mongodb.client.MongoCollection" %>
<%@page import = "com.mongodb.client.MongoCursor" %> 
<%@page import = "com.mongodb.client.MongoDatabase" %> 
<%@page import = "org.bson.Document" %>  
<%@page import = "com.mongodb.DBObject" %>
<%@page import = "com.mongodb.DBCollection" %>
<%@page import = "com.mongodb.DB" %>
<%@page import = "com.mongodb.client.FindIterable" %>
<%@page import = "java.util.ArrayList" %>   
<%@page import = "java.util.List" %> 
<%@page import = "java.util.Iterator" %> 
<%@page import = "com.mongodb.BasicDBList" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Restaurant Details</title>
</head>
<style>
.text{
text-align: center;
}
.color{
background-color: pink;
}
</style>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<link rel="stylesheet" href="path/to/font-awesome/css/font-awesome.min.css">

<body class = "color">

<br><br>
<%
MongoClient mongoClient = new MongoClient("localhost",27017);
MongoDatabase db = mongoClient.getDatabase("sample_restaurants");
MongoCollection<Document> restaurants = db.getCollection("restaurants");
MongoCollection<Document> neighborhoods = db.getCollection("neighborhoods");
Document regexQuerry = new Document();
regexQuerry.append("$regex",".*(?i)" + request.getParameter("name") + ".*");
BasicDBObject querry = new BasicDBObject("name",regexQuerry);
FindIterable<Document> iter = restaurants.find(querry);
MongoCursor<Document> cursor = iter.iterator();
Document result = null;
result = (Document)cursor.next();
Document addr = result.get("address",Document.class);
String address = addr.getString("building") +", "+ addr.getString("street") +", "+ result.getString("borough") +", "+ "NY "+ addr.getString("zipcode");
String restaurant_id = result.getString("restaurant_id");
// Iterating through grades : 
int total_rating = 0; 
int average_rating = 0;
ArrayList<Document> list = (ArrayList<Document>)result.get("grades");
Document grade_list = list.get(0);

	
	
%>
<div>
<h1 class = "p-1 mb-0 bg-dark text-white"><%= result.getString("name")%>
</h1>
</div>

<div>
<ul class="list-group list-group-flush">
<li class="list-group-item">Cuisine : <%= result.getString("cuisine") %></li>
<li class="list-group-item">Address : <%= address %></li>
<li class="list-group-item">Rating : <%= grade_list.getString("grade") %></li>
<form action = "reviews_check.jsp">
 <input type = "hidden" name = "rest_id" value = "<%= restaurant_id %>">
<input class="btn btn-primary" type="submit" value = "check reviews">
</form>
</ul>
</div>
<br>
<form action="http://maps.google.com/maps" method="get" target="_blank">
   <input type="text" name="saddr" placeholder = "Enter your location" />
   <input type="hidden" name="daddr" value= "<%= address %>" />
   <input type="submit"  class="btn btn-primary" value="Get directions" />
</form>
<br>
<form action = "reviews.jsp">
  <label  style = "font-weight: bold;" for = "exampleFormControlInput1" >Enter your name before writing a review</label><br>
  <input type="text" class="form-control" id="exampleFormControlInput1" name = "reviewer_name">
  <br>
  <textarea class="form-control z-depth-1" id="exampleFormControlTextarea6" rows="3" name = "customer_review" placeholder="Write your review here !!"></textarea>
  <input type = "hidden" name = "rest_id" value = "<%= restaurant_id %>"> <br>
<input class="btn btn-primary" type="submit" value="submit-review">
</form>


<div class="fixed-bottom">
<div class = "p-3 mb-2 bg-dark text-white">
<input class="btn btn-primary" type="submit" value="Home" id = "home-button">
<input class="btn btn-primary" type="submit" value="Search Page" id = "search-button">
</div>
</div>

<script>
document.getElementById("home-button").addEventListener("click",myFunction);
function myFunction(){
	window.location.href = "home.jsp";
}


</script>
<script>
document.getElementById("search-button").addEventListener("click",myFunction);
function myFunction(){
	window.location.href = "Search.jsp";
}
</script>
</body>
</html>
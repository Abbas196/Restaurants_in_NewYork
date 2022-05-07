<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import = "com.mongodb.MongoClient" %>
<%@page import = "com.mongodb.BasicDBObject" %>
<%@page import = "com.mongodb.BasicDBList" %>
<%@page import = "com.mongodb.client.MongoCollection" %>
<%@page import = "com.mongodb.client.MongoCursor" %> 
<%@page import = "com.mongodb.client.MongoDatabase" %> 
<%@page import = "org.bson.Document" %>  
<%@page import = "org.bson.BsonDocument" %>  
<%@page import = "com.mongodb.DBObject" %>
<%@page import = "com.mongodb.DBCollection" %>
<%@page import = "com.mongodb.DB" %>
<%@page import = "com.mongodb.client.FindIterable" %>
<%@page import = "java.util.ArrayList" %>
    
<!DOCTYPE html>
<html>
<head>
<style>
body  {
  background-image: url("Images/pexels-fwstudio-129731.jpg");
  background-repeat: no-repeat;
  background-size: cover;
}
.center {
  display: block;
  margin-left: auto;
  margin-right: auto;
}
</style>
<meta charset="ISO-8859-1">
<title>Reviews</title>
</head>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<link rel="stylesheet" href="path/to/font-awesome/css/font-awesome.min.css">
<body>
<% String id = request.getParameter("rest_id");
String review = request.getParameter("customer_review");
MongoClient mongoClient = new MongoClient("localhost",27017);
MongoDatabase db = mongoClient.getDatabase("sample_restaurants");
MongoCollection<Document> restaurants = db.getCollection("restaurants");

// Searching the results :

Document regexQuerry = new Document();
regexQuerry.append("$regex",".*(?i)" + request.getParameter("rest_id") + ".*");
BasicDBObject querries = new BasicDBObject("restaurant_id",regexQuerry);
FindIterable<Document> iter = restaurants.find(querries);
MongoCursor<Document> cursor = iter.iterator();
Document result = null;
result = (Document)cursor.next();
ArrayList<Document> list;
list = (ArrayList<Document>) result.get("reviews");
if(list == null){
%>
<h1 style = "text-align: center; margin: 30px;font-weight: bold;">No reviews available. If you want to give any review kindly check 
the review section on the previous page and submit the review. </h1>
<br>
<img alt="image not available" src="Images/empty-plate-modified.png" class = "center">
<% } else{ %>
<div style = "margin: auto; font-size: 20px;font-weight: bold;">
<ul style = "margin-top: 70px;" >
<%
for(int i = 0;i<list.size();i++){
	
if(list.size() == 0){
%>
<p>No reviews available yet.</p>
<% } else{
	%>

<li><%=  "Name : " + list.get(i).getString("Name")%></li>
<p><%= "Review : "+ list.get(i).getString("review") %></p>

<% }}}%>
</div>
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
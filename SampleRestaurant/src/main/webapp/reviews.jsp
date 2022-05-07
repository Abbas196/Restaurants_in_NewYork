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
<%@page import = "com.mongodb.client.result.UpdateResult" %>
<%@page import = "com.mongodb.client.model.Filters" %>
<%@page import = "com.mongodb.client.model.UpdateOptions" %>  
<%@page import = "com.mongodb.client.model.Updates" %>  
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<link rel="stylesheet" href="path/to/font-awesome/css/font-awesome.min.css">
<body>
<% String review = request.getParameter("customer_review");
MongoClient mongoClient = new MongoClient("localhost",27017);
MongoDatabase db = mongoClient.getDatabase("sample_restaurants");
MongoCollection<Document> restaurants = db.getCollection("restaurants");
Document querry = new Document();
String id = request.getParameter("rest_id");
String name = request.getParameter("reviewer_name");
// Updating the document adding reviews with attributes name and review per customer.
Document review_data = new Document().append("Name",name).append("review", review);
UpdateResult update_querry_result = restaurants.updateOne(Filters.eq("restaurant_id",id),
		Updates.addToSet("reviews",review_data));

// Fetching the name of the reviewer to display on the user interface.

Document regexQuerry = new Document();
regexQuerry.append("$regex",".*(?i)" + request.getParameter("rest_id") + ".*");
BasicDBObject querries = new BasicDBObject("restaurant_id",regexQuerry);
FindIterable<Document> iter = restaurants.find(querries);
MongoCursor<Document> cursor = iter.iterator();
Document result = null;
result = (Document)cursor.next();
ArrayList<Document> list = (ArrayList<Document>) result.get("reviews");
Document recent_review = list.get(list.size()-1);
String reviewer_name = recent_review.getString("Name");
%>
<h1 style = "margin-top: 40px">Thank you very much for such a great review, We work really hard to offer the best meal in the best possible ambience.
Hope to see you again! Wow, Thanks for this awesome review  '<%= reviewer_name  %>'.
</h1>
<img alt="image" src="https://t3.ftcdn.net/jpg/03/43/48/90/240_F_343489025_Byvnjdh1OwQWBRf0MMrgqXJn7bKcW1lY.jpg">
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
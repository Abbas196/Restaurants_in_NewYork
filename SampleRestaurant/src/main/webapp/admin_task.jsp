<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<%@page import="com.mongodb.MongoClient"%>
<%@page import="com.mongodb.client.MongoCollection"%>
<%@page import="com.mongodb.client.MongoDatabase"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.io.*"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.io.FileUtils" %>
<%@page import="org.bson.Document"%>
<%@page import="com.mongodb.DBCollection"%>
<%@page import="com.mongodb.client.model.InsertOneModel" %>
<%@page import="com.mongodb.client.model.BulkWriteOptions" %>
<%@page import="com.mongodb.client.model.Filters"%>
<%@page import="org.bson.types.ObjectId" %>
<%@page import="com.mongodb.client.FindIterable"%>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
try {
	MongoClient mongoClient = new MongoClient("localhost", 27017);
	System.out.println("MongoDB connected......");

	
	MongoDatabase db = mongoClient.getDatabase("sample_restaurants");
	System.out.println("Database connected......");

	MongoCollection<Document> restaurants = db.getCollection("restaurants");
	System.out.println("restaurants Collection connected ......");
	
	MongoCollection<Document> neighborhoods = db.getCollection("neighborhoods");
	System.out.println("neighborhoods Collection connected ......");
	
	String radio_button_selected = request.getParameter("type");
 
     if(radio_button_selected.equals("Insert"))
     {
    	 
    	 String file_name = request.getParameter("myfile");
    	    String collection_name = request.getParameter("collection");
    	    
    	    String path = "C:/documents/";
    	    path = path + file_name;
    	    
    		String jsonString = FileUtils.readFileToString(new File(path), "UTF-8");

    		 Document doc = Document.parse(jsonString);
    	     List<Document> list = new ArrayList<>();
    	     list.add(doc);
    	    
   if(collection_name.equals("Restaurants")) 
   {
     
     restaurants.insertMany(list);     

   }
  
    
    if(collection_name.equals("Neighborhoods")) 
    {
    	neighborhoods.insertMany(list);
    	
    }
    %>

	<h1> Document inserted Successfully
<%
     }
    
     if(radio_button_selected.equals("Delete"))
     {
    	 
    	 String id = request.getParameter("id") ;
    	  String collection_name_selected = request.getParameter("collection");
    	 System.out.println(""+id);
    	 System.out.println(""+collection_name_selected);
    	 
  if(collection_name_selected.equals("Restaurants")) 
     
  restaurants.deleteOne(new Document("_id", new ObjectId(id)));
    
    if(collection_name_selected.equals("Neighborhoods")) 
    	
    neighborhoods.deleteOne(new Document("_id", new ObjectId(id)));
     //new MongoClient().getDatabase("test2").getCollection("collection1").insertMany(list);
      
%>	
		<h1>Document Deleted Successfully
<%
     }
        String username = session.getAttribute("username").toString();
     	String password = session.getAttribute("password").toString();
    // 	response.sendRedirect("http://localhost:8080/SampleRestaurant/admin.jsp"+"?username="+username+"&password="+password);
    
}

catch (Exception e){
	e.printStackTrace(); 
	
%>
		<h1> Something went wrong!! Please try again!!</h1>
<%
}
     	
%>

</body>

<script>

setTimeout(function() {
	var username = '${username}';
	var password = '${password}';
   document.location = "http://localhost:8080/SampleRestaurant/admin.jsp"+"?username="+username+"&password="+password;
 }, 3000); // <-- this is the delay in milliseconds
</script>




</html>
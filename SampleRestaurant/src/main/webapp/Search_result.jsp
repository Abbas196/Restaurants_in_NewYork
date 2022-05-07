<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<%@page import="com.mongodb.MongoClient"%>
<%@page import="com.mongodb.BasicDBObject"%>
<%@page import="com.mongodb.BasicDBList"%>
<%@page import="com.mongodb.client.MongoCollection"%>
<%@page import="com.mongodb.client.MongoCursor"%>
<%@page import="com.mongodb.client.MongoDatabase"%>
<%@page import="org.bson.Document"%>
<%@page import="com.mongodb.client.FindIterable"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="com.mongodb.DBCursor"%>
<%@page import="com.mongodb.DBCollection"%>
<%@page import="com.mongodb.DB"%>
<%@page import="java.util.stream.Collectors"%>
<%@page import="com.mongodb.client.model.Filters"%>
<%@page import="com.mongodb.client.model.geojson.Point"%>
<%@page import="static com.mongodb.client.model.Filters.near"%>
<%@page import="org.bson.conversions.Bson"%>
<%@page import="com.mongodb.client.model.Projections"%>
<%@page import="static com.mongodb.client.model.Projections.include"%>
<%@page import="static com.mongodb.client.model.Projections.fields"%>
<%@page import="static com.mongodb.client.model.Projections.excludeId"%>
<%@page import="com.mongodb.client.model.geojson.Position"%>
<%@page import="com.mongodb.client.model.geojson.Point"%>

<html>
<head>
<meta charset="ISO-8859-1">
<title>Search page</title>
<link href="CSS/table.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
<meta charset="ISO-8859-1">
</head>
<body>

	<br>
	<br>
    <div class="cont">
	<table class="container" border="1" align="center" style="font-size: 150%;">
		<tr>
			<th >Restaurant Name</th>
		</tr>

		<%
		MongoClient mongoClient = new MongoClient("localhost", 27017);
		System.out.println("MongoDB connected......");

		
		MongoDatabase db = mongoClient.getDatabase("sample_restaurants");
		System.out.println("Database connected......");

		MongoCollection<Document> neighborhoods = db.getCollection("neighborhoods");
		System.out.println("neighborhoods Collection connected ......");

		MongoCollection<Document> restaurants = db.getCollection("restaurants");
		System.out.println("restaurants Collection connected ......");

		Document regexQuery = new Document();
		regexQuery.append("$regex", ".*(?i)" + request.getParameter("keyword") + ".*");

		      
		List obj = new ArrayList();
		List obj1 = new ArrayList();

		String regexQuery_op = regexQuery.toString();
		String borough_op = request.getParameter("borough");
		String cuisine_op = request.getParameter("cuisine");
		String neighborhoods_op = request.getParameter("neighborhoods");
		String max_distance = request.getParameter("distance");
		System.out.println("distance:  " + request.getParameter("max_distance"));
		Double distance;
		if (borough_op == null)
			borough_op = "default";

		if (neighborhoods_op == null)
			neighborhoods_op = "default";

		System.out.println("keyword:    " + regexQuery);
		System.out.println("borough:  " + request.getParameter("borough"));
		System.out.println("cuisine:  " + request.getParameter("cuisine"));
		System.out.println("neighborhoods:  " + request.getParameter("neighborhoods"));

		BasicDBObject whereQuery = new BasicDBObject();
		

		// given - name, cuisine, borough
		if ((!regexQuery_op.contains(".*(?i).*") && !borough_op.contains("default") && !cuisine_op.contains("default"))) {
			System.out.println("name cusine and borough");
			obj.add(new BasicDBObject("name", regexQuery));
			obj.add(new BasicDBObject("borough", request.getParameter("borough")));
			obj.add(new BasicDBObject("cuisine", request.getParameter("cuisine")));
			whereQuery.put("$and", obj);
			obj1 = restaurant_finder(whereQuery, restaurants);
			for (int i = 0; i < obj1.size(); i++) {
		%>
		<tr>
			<td>
			<a href = "restaurant.jsp?name=<%=obj1.get(i)%>"><%=obj1.get(i)%></a>
			
			</td>

			<%
			}
			}
		
			// given - keyword, neighborhoods, cuisine
			else if ((!regexQuery_op.contains(".*(?i).*") && !neighborhoods_op.contains("default")
					&& !cuisine_op.contains("default"))) {

			System.out.println("name cusine and neighborhoods");
			obj.add(new BasicDBObject("name", regexQuery));
			obj.add(new BasicDBObject("cuisine", request.getParameter("cuisine")));
			if(max_distance != "null")
			distance = Double.parseDouble(max_distance);
			else
			distance = 0.0;
			whereQuery.put("$and", obj);
			FindIterable<Document> restaurants_cursor = restaurants.find(whereQuery);
			Document res = restaurants_cursor.first();
			if (res != null) {
			for (Document result : restaurants_cursor) {
				String restaurant_name = result.get("name").toString();
				System.out.println("restaurant_name :" + restaurant_name);
				Document geometry = result.get("address", Document.class);

				String geometry_coordinates = geometry.get("coord").toString();
				geometry_coordinates = geometry_coordinates.replaceAll("[[\\[\\](){}]]", "");
				String[] arrOfStr = geometry_coordinates.split(",", 2);

				Double geometry_coordinates_longitude = Double.parseDouble(arrOfStr[0]);
				Double geometry_coordinates_latitude = Double.parseDouble(arrOfStr[1]);
				

				Point coordinates = new Point(new Position(geometry_coordinates_longitude, geometry_coordinates_latitude));
				Boolean restaurant_in_neighborhood = isrestaurant_in_given_neighborhoods(restaurant_name, coordinates,
				neighborhoods_op, neighborhoods, distance);
				if (restaurant_in_neighborhood == true) {
			%>
		
		<tr>
			<td>
			<a href = "restaurant.jsp?name=<%=restaurant_name%>"><%=restaurant_name%></a>		
			</td>

			<%
			} //if(restaurant_in_neighborhood == true)

			} //for(Document result : restaurants_cursor)
			} //if(res != null)
			else {
			%>
		
		<tr>
			<td><%="No Restaurants found based on your search criteria!!"%></td>

			<%
			} //else   	

			} //else if
			
			// given - keyword, neighborhoods 
			else if (!regexQuery_op.contains(".*(?i).*") && !neighborhoods_op.contains("default")) {

			System.out.println("name and neighborhoods");
			obj.add(new BasicDBObject("name", regexQuery));
			if(max_distance != "default")
			distance = Double.parseDouble(max_distance);
			else
			distance = 0.0;
			whereQuery.put("$and", obj);
			FindIterable<Document> restaurants_cursor = restaurants.find(whereQuery);
			Document res1 = restaurants_cursor.first();
			if (res1 != null) {
			for (Document result : restaurants_cursor) {
				String restaurant_name = result.get("name").toString();

				Document geometry = result.get("address", Document.class);

				String geometry_coordinates = geometry.get("coord").toString();
				geometry_coordinates = geometry_coordinates.replaceAll("[[\\[\\](){}]]", "");
				String[] arrOfStr = geometry_coordinates.split(",", 2);

				Double geometry_coordinates_longitude = Double.parseDouble(arrOfStr[0]);
				Double geometry_coordinates_latitude = Double.parseDouble(arrOfStr[1]);
				

				Point coordinates = new Point(new Position(geometry_coordinates_longitude, geometry_coordinates_latitude));
				Boolean restaurant_in_neighborhood = isrestaurant_in_given_neighborhoods(restaurant_name, coordinates,
				neighborhoods_op, neighborhoods, distance);
				if (restaurant_in_neighborhood == true) {

					
			%>
		
		<tr>
			<td>
			<a href = "restaurant.jsp?name=<%=restaurant_name%>"><%=restaurant_name%></a>		
			</td>

			<%
			} //if(restaurant_in_neighborhood == true)

			} //for(Document result : restaurants_cursor)
			} //if(res1 != null)

			else {
			%>
		
		<tr>
			<td><%="No Restaurants found based on your search criteria!!"%></td>

			<%
			} //else   	

			} //else if

			// given - cuisine, neighborhoods 
			else if (!cuisine_op.contains("default") && !neighborhoods_op.contains("default")) {

			System.out.println("cuisine and neighborhoods");
			obj.add(new BasicDBObject("cuisine", request.getParameter("cuisine")));
			if(max_distance != "default")
			distance = Double.parseDouble(max_distance);
			else
			distance = 0.0;
			whereQuery.put("$and", obj);
			FindIterable<Document> restaurants_cursor = restaurants.find(whereQuery);

			for (Document result : restaurants_cursor) {
			String restaurant_name = result.get("name").toString();
			System.out.println(restaurant_name);
			Document geometry = result.get("address", Document.class);

			String geometry_coordinates = geometry.get("coord").toString();
			geometry_coordinates = geometry_coordinates.replaceAll("[[\\[\\](){}]]", "");
			String[] arrOfStr = geometry_coordinates.split(",", 2);

			Double geometry_coordinates_longitude = Double.parseDouble(arrOfStr[0]);
			Double geometry_coordinates_latitude = Double.parseDouble(arrOfStr[1]);
			

			Point coordinates = new Point(new Position(geometry_coordinates_longitude, geometry_coordinates_latitude));
			Boolean restaurant_in_neighborhood = isrestaurant_in_given_neighborhoods(restaurant_name, coordinates, neighborhoods_op,
					neighborhoods, distance);
			if (restaurant_in_neighborhood == true) {
			%>
		
		<tr>
			<td>
			<a href = "restaurant.jsp?name=<%=restaurant_name%>"><%=restaurant_name%></a>		
			</td>

			<%
			} //if(restaurant_in_neighborhood == true)
			} //for(Document result : restaurants_cursor)
			} //else if    			    	 

			//neighborhoods
			else if (!neighborhoods_op.contains("default")) {
			if(max_distance != "default")
			distance = Double.parseDouble(max_distance);
			else
			distance = 0.0;
			System.out.println("neighborhoods");
			FindIterable<Document> restaurants_cursor = restaurants.find().limit(1000);

			for (Document result : restaurants_cursor) {
			String restaurant_name = result.get("name").toString();
			System.out.println(restaurant_name);
			Document geometry = result.get("address", Document.class);

			String geometry_coordinates = geometry.get("coord").toString();
			geometry_coordinates = geometry_coordinates.replaceAll("[[\\[\\](){}]]", "");
			String[] arrOfStr = geometry_coordinates.split(",", 2);

			Double geometry_coordinates_longitude = Double.parseDouble(arrOfStr[0]);
			Double geometry_coordinates_latitude = Double.parseDouble(arrOfStr[1]);
			

			Point coordinates = new Point(new Position(geometry_coordinates_longitude, geometry_coordinates_latitude));
			Boolean restaurant_in_neighborhood = isrestaurant_in_given_neighborhoods(restaurant_name, coordinates, neighborhoods_op,
					neighborhoods, distance);
			if (restaurant_in_neighborhood == true) {
			%>
		
		<tr>
			<td>
			<a href = "restaurant.jsp?name=<%=restaurant_name%>"><%=restaurant_name%></a>		
			</td>

			<%
			} //if(restaurant_in_neighborhood == true)
			} //for(Document result : restaurants_cursor)
			} //else if    			    	 

			//given keyword, cuisine    	   
			else if ((!regexQuery_op.contains(".*(?i).*") && !cuisine_op.contains("default"))) {
			System.out.println("name and cuisine");
			obj.add(new BasicDBObject("name", regexQuery));
			obj.add(new BasicDBObject("cuisine", request.getParameter("cuisine")));
			whereQuery.put("$and", obj);
			obj1 = restaurant_finder(whereQuery, restaurants);
			for (int i = 0; i < obj1.size(); i++) {
			%>
		
		<tr>
			<td>
			<a href = "restaurant.jsp?name=<%=obj1.get(i)%>"><%=obj1.get(i)%></a>		
			</td>

			<%
			}

			}
		
			//given keyword, borough
			else if (!regexQuery_op.contains(".*(?i).*") && !borough_op.contains("default")) {
			System.out.println("name and borough");
			obj.add(new BasicDBObject("name", regexQuery));
			obj.add(new BasicDBObject("borough", request.getParameter("borough")));
			whereQuery.put("$and", obj);
			obj1 = restaurant_finder(whereQuery, restaurants);
			for (int i = 0; i < obj1.size(); i++) {
			%>
		
		<tr>
			<td>
			<a href = "restaurant.jsp?name=<%=obj1.get(i)%>"><%=obj1.get(i)%></a>		
			</td>

			<%
			}
			}
		
			//given borough, cuisine
			else if (!borough_op.contains("default") && !cuisine_op.contains("default")) {
			System.out.println("borough and cuisine");
			obj.add(new BasicDBObject("borough", request.getParameter("borough")));
			obj.add(new BasicDBObject("cuisine", request.getParameter("cuisine")));
			whereQuery.put("$and", obj);
			obj1 = restaurant_finder(whereQuery, restaurants);
			for (int i = 0; i < obj1.size(); i++) {
			%>
		
		<tr>
			<td>
			<a href = "restaurant.jsp?name=<%=obj1.get(i)%>"><%=obj1.get(i)%></a>		
			</td>

			<%
			}
			}
			//given keyword
			else if (!regexQuery_op.contains(".*(?i).*")) {
			System.out.println("name");
			obj.add(new BasicDBObject("name", regexQuery));
			whereQuery.put("$and", obj);
			obj1 = restaurant_finder(whereQuery, restaurants);
			for (int i = 0; i < obj1.size(); i++) {
			%>
		
		<tr>
			<td>
			<a href = "restaurant.jsp?name=<%=obj1.get(i)%>"><%=obj1.get(i)%></a>		
			</td>

			<%
			}
			}
			//given keyword
			else if (!borough_op.contains("default")) {
			System.out.println("borough");
			obj.add(new BasicDBObject("borough", request.getParameter("borough")));
			whereQuery.put("$and", obj);
			obj1 = restaurant_finder(whereQuery, restaurants);
			for (int i = 0; i < obj1.size(); i++) {
			%>
		
		<tr>
			<td>
			<a href = "restaurant.jsp?name=<%=obj1.get(i)%>"><%=obj1.get(i)%></a>		
			</td>

			<%
			}
			}
			//given keyword
			else if (!cuisine_op.contains("default")) {
			System.out.println("cuisine");
			obj.add(new BasicDBObject("cuisine", request.getParameter("cuisine")));
			whereQuery.put("$and", obj);
			obj1 = restaurant_finder(whereQuery, restaurants);
			for (int i = 0; i < obj1.size(); i++) {
			%>
		
		<tr>
			<td>
			<a href = "restaurant.jsp?name=<%=obj1.get(i)%>"><%=obj1.get(i)%></a>		
			</td>

			<%
			}
			}
			%>


		<%!
			public Boolean isrestaurant_in_given_neighborhoods(String restaurant_name, Point coordinates,
			String neighborhoods_op, MongoCollection<Document> neighborhoods, Double distance) {
			System.out.println("inside function.................................");
			Boolean restarant_in_given_neighborhoods = false;
			String res_name = restaurant_name;
			Point p = coordinates;
			String n_name = neighborhoods_op;
			Double max_dist = distance * 1609.34;
			MongoCollection<Document> neighborhoods_collection = neighborhoods;
			//System.out.println("restaurant_name :"+ res_name);
			Bson query = near("geometry", p, max_dist, 0.0);
			Bson projection = fields(include("name"), excludeId());
			FindIterable<Document> n_cursor = neighborhoods.find(query).projection(projection);

			for (Document doc : n_cursor) {

				if (doc.getString("name").equals(n_name)) {
				restarant_in_given_neighborhoods = true;
				System.out.println("neighborhoods name:   "+doc.getString("name") );
				}
			}

		return restarant_in_given_neighborhoods;
			}
		%>


		<%!public List<String> restaurant_finder(BasicDBObject whereQuery, MongoCollection<Document> restaurants) {
					FindIterable<Document> cursor = restaurants.find(whereQuery);
					Document result = cursor.first();
					List<String> ls_res = new ArrayList();
					;
					String s = null;
					if (result == null) {
						s = "No Result Found based on your search Criteria!!";
						ls_res.add(s);
						return ls_res;
					}
				
					else {
						for (Document doc : cursor) {
							if (!doc.getString("name").equals("")) {
								s = doc.getString("name");
								ls_res.add(s);
							} // if(!doc.getString("name").equals(""))
						} //for(Document doc : cursor)
					}
					return ls_res;
		}
		%>
		</div>
</body>
</html>
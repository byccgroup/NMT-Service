<?xml version="1.0" encoding="UTF-8" ?>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Insert title here</title>
</head>
<body>
	<s:property value="#request.List" />
	<% String str = (String)request.getAttribute("List"); %>

	<s:textarea name="#request.List" readonly="true" style="background-color:#E0E0E0; margin-left:10%; margin-top:3px; margin-bottom:3px; width:80%; height:270px; float:left"></s:textarea>
	<p>goods</p>
</body>
</html>
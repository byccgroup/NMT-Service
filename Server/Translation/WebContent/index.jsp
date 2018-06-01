<?xml version="1.0" encoding="UTF-8" ?>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Amunmt文本翻译测试</title>
	<style type="text/css">
		body {background-color:#F8F8F8}
		p{color:blue}
		div{height:700px}
	</style>
	<script type="text/JavaScript" src="js/jquery-1.2.6.min.js"></script>
	<script type="text/javascript">
		$(document).ready(function(){
			$("#btn_translation").click(function(){
				var url = "sendText";
				var params = {inputtext:$("#inputtext").val()}; 
				$.post(url, params, function qwer(data){
					var member = eval("("+data+")");
					$('#result').html(member.result);
				},
				'json'
				);
			});
		});
		
	</script>
</head>

<body>
	<div id="header" style="background-color:#282828; width:100%; height:50px">
	</div>
	<div id="left" style="background-color:#D0D0D0; width:20%; float:left"></div>
	<div id="main" style="width:60%; float:left">
		<!-- 文本表单action="sendText" method="post" theme="simple"  -->
		<form >
			<!-- 输入文本域  -->
			<textarea id="inputtext" name="inputtext" style="background-color:#E0E0E0; margin-left:10%; margin-top:30px; margin-bottom:3px; width:80%; height:270px; float:left"></textarea>
			<div style=" margin-left:10%; width:80%; height:50px; float:left">
				<input type="button" id="btn_translation" style="width:100px; height:30px; margin-top:10px;" value="开始翻译"></input>
			</div>
		</form>
		<!-- 输出文本域  -->
		<textarea id="result" disabled="disabled" style="background-color:#E0E0E0; margin-left:10%; margin-top:3px; margin-bottom:3px; width:80%; height:270px; float:left">	
		</textarea>
	</div>
	<div id="right" style="background-color:#D0D0D0; width:20%; float:left"></div>
</body>
</html>
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
				$('#result').html("");
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
		
		var autoTextarea = function (elem, extra, maxHeight) {
	        extra = extra || 0;
	        var isFirefox = !!document.getBoxObjectFor || 'mozInnerScreenX' in window,
	        isOpera = !!window.opera && !!window.opera.toString().indexOf('Opera'),
	                addEvent = function (type, callback) {
	                        elem.addEventListener ?
	                                elem.addEventListener(type, callback, false) :
	                                elem.attachEvent('on' + type, callback);
	                },
	                getStyle = elem.currentStyle ? function (name) {
	                        var val = elem.currentStyle[name];
	                        
	                        if (name === 'height' && val.search(/px/i) !== 1) {
	                                var rect = elem.getBoundingClientRect();
	                                return rect.bottom - rect.top -
	                                        parseFloat(getStyle('paddingTop')) -
	                                        parseFloat(getStyle('paddingBottom')) + 'px';        
	                        };
	                        
	                        return val;
	                } : function (name) {
	                                return getComputedStyle(elem, null)[name];
	                },
	                minHeight = parseFloat(getStyle('height'));
	        
	        
	        elem.style.resize = 'none';
	        
	        var change = function () {
	                var scrollTop, height,
	                        padding = 0,
	                        style = elem.style;
	                
	                if (elem._length === elem.value.length) return;
	                elem._length = elem.value.length;
	                
	                if (!isFirefox && !isOpera) {
	                        padding = parseInt(getStyle('paddingTop')) + parseInt(getStyle('paddingBottom'));
	                };
	                scrollTop = document.body.scrollTop || document.documentElement.scrollTop;
	                
	                elem.style.height = minHeight + 'px';
	                if (elem.scrollHeight > minHeight) {
	                        if (maxHeight && elem.scrollHeight > maxHeight) {
	                                height = maxHeight - padding;
	                                style.overflowY = 'auto';
	                        } else {
	                                height = elem.scrollHeight - padding;
	                                style.overflowY = 'hidden';
	                        };
	                        style.height = height + extra + 'px';
	                        scrollTop += parseInt(style.height) - elem.currHeight;
	                        document.body.scrollTop = scrollTop;
	                        document.documentElement.scrollTop = scrollTop;
	                        elem.currHeight = parseInt(style.height);
	                };
	        };
	        
	        addEvent('propertychange', change);
	        addEvent('input', change);
	        addEvent('focus', change);
	        change();
	};
	</script>
</head>

<body>
	<div id="header" style="background-color:#282828; width:100%; height:50px">
	</div>
	<div id="left" style="background-color:#D0D0D0; width:10%; float:left"></div>
	<div id="main" style="width:80%; float:left">
		<!-- 文本表单action="sendText" method="post" theme="simple"  -->
		<form >
			<!-- 提交按钮 -->
			<div id="button" style="width:100%; height:50px;">
				<input type="button" id="btn_translation" style="width:100px; height:30px;  margin-top:10px;" value="开始翻译"></input>
				<input type="reset" style="width:100px; height:30px;" value="重置"></input>
			</div>
		<div style="height:250px; width:100%; background-color:#FFCCFF">
			<!-- 输入文本域  -->
			<div id="left_text" style="width:50%; height:100%; float:left;" >
				<textarea id="inputtext" name="inputtext" style="background-color:#E0E0E0; margin-bottom:3px; width:100%; float:left"></textarea>
				<script>
					var text = document.getElementById("inputtext");
					autoTextarea(text);
				</script>
			</div>
			<!-- 输出文本域  -->
			<div id="right_text" style="width:50%; height:100%; float:left">
				<textarea id="result"  style="background-color:#E0E0E0;  margin-bottom:3px; width:100%; float:left"></textarea>
			</div>
		</div>
		</form>

	</div>
	<div id="right" style="background-color:#D0D0D0; width:10%; float:left"></div>
</body>
</html>
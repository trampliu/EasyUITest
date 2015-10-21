<%@ page import="java.util.ArrayList" %>


<%--
  Created by IntelliJ IDEA.
  User: leo
  Date: 15/9/30
  Time: 上午10:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="keywords" content="jquery,ui,easy,easyui,web">
	<base href="${pageContext.request.contextPath}/">
	<meta name="description" content="easyui help you build your web page easily!">
	<title>jQuery EasyUI CRUD Demo</title>
	<link rel="stylesheet" type="text/css" href="http://www.jeasyui.net/Public/js/easyui/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="http://www.jeasyui.net/Public/js/easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="http://www.jeasyui.net/Public/js/easyui/demo/demo.css">
	<style type="text/css">
		#fm{
			margin:0;
			padding:10px 30px;
		}
		.ftitle{
			font-size:14px;
			font-weight:bold;
			color:#666;
			padding:5px 0;
			margin-bottom:10px;
			border-bottom:1px solid #ccc;
		}
		.fitem{
			margin-bottom:5px;
		}
		.fitem label{
			display:inline-block;
			width:80px;
		}
	</style>
	<script type="text/javascript" src="http://code.jquery.com/jquery-1.6.min.js"></script>
	<script type="text/javascript" src="http://www.jeasyui.net/Public/js/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript">
		var url;
		function newUser(){
			$('#dlg').dialog('open').dialog('setTitle','New User');
			$('#fm').form('clear');
			findGoodsKinds(document.getElementById("kinds")); // get the goods' kind 如果页面加载时就调用这个方法，会出现值被清空一次的情况，默认选中的Option就无值
			url = 'goods/addGoods';
		}
		function editUser(){
			var row = $('#dg').datagrid('getSelected');
			if (row){
				$('#dlg').dialog('open').dialog('setTitle','Edit User');
				$('#fm').form('load',row);
				url = 'goods/updateGoods?id='+row.id;
			}
		}
		function saveUser(){
			$('#fm').form('submit',{
				url: url,
				onSubmit: function(){
					return $(this).form('validate');
				},
				success: function(result){
					var result = eval('('+result+')');
					if (result.success){
						$('#dlg').dialog('close');		// close the dialog
						$('#dg').datagrid('reload');	// reload the user data reload请求当前页面数据 load 请求所有数据
						alert("保存成功");
					} else {
						$.messager.show({
							title: 'Error',
							msg: result.msg
						});
					}
				}
			});
		}
		function removeUser(){
			var row = $('#dg').datagrid('getSelected');
			if (row){
				$.messager.confirm('Confirm','Are you sure you want to remove this user?',function(r){
					if (r){
						$.post('goods/deleteGoods',{id:row.id},function(result){
							if (result.success){
								$('#dg').datagrid('reload');	// reload the user data
								alert("删除成功");
							} else {
								$.messager.show({	// show error message
									
								});
							}
						},'json');
					}
				});
			}
		}
		//  获取类型
		function findGoodsKinds(kindsSelectionTag){
			$.ajax({

		        type: 'POST',

		        url: "goods/getGoodsKind" ,

		        success: function (data) {
		        	spliteKindsStr(data,kindsSelectionTag);
		        }

		      });
			
		}
		//  拆分传回的类型参数
		function spliteKindsStr(kindsStr,kindsSelectionTag){
			$(kindsSelectionTag).find('option').remove(); // 先清空一次
			var kindsArr = kindsStr.split("*");
			for(var i=0;i<kindsArr.length;i++){
				if (i==0){
					kindsSelectionTag.add(new Option(kindsArr[i],kindsArr[i]),true,true);
				}else{
					kindsSelectionTag.add(new Option(kindsArr[i],kindsArr[i]));
				}
			
			}
		}
		
		// 计算总额
		function caculateSumPrice(){
			var element = document.goodsfm.sumprice;
		    var price = document.goodsfm.price.value;
		    var number = document.goodsfm.num.value;
		    element.value = price * number;
		    
		}
		// 搜索
		function doSearch(){
			$('#dg').datagrid('reload',{
				searchkind: $('#searchkind').val(),
				searchname: $('#searchname').val()
			});
		}
		
		$(document).ready(function(){
			$('#dg').datagrid({
	            title : 'datagrid实例',
	            iconCls : 'icon-ok',
	            width : 600,
	            pageSize : 5,//默认选择的分页是每页5行数据
	            pageList : [ 5, 10, 15, 20 ],//可以选择的分页集合
	            nowrap : true,//设置为true，当数据长度超出列宽时将会自动截取
	            striped : true,//设置为true将交替显示行背景。
	            collapsible : true,//显示可折叠按钮
	            toolbar:"#tb",//在添加 增添、删除、修改操作的按钮要用到这个
	            url:'goods/showGoods',//url调用Action方法
	            loadMsg : '数据装载中......',
	            singleSelect:true,//为true时只能选择单行
	            fitColumns:true,//允许表格自动缩放，以适应父容器
	            //sortName : 'xh',//当数据表格初始化时以哪一列来排序
	            //sortOrder : 'desc',//定义排序顺序，可以是'asc'或者'desc'（正序或者倒序）。
	            remoteSort : false,
	             frozenColumns : [ [ {
	                field : 'ck',
	                checkbox : true
	            } ] ],
	            pagination : true,//分页
	            rownumbers : true//行数
	        }); 
		});
		
	</script>	
  </head>
  

<body>
<!-- EasyUI中的列表； field的名字要和数据库的key相同-->
<table id="dg">
	<thead>
		<tr>
		<!-- 这里的field 所对应的key，要和服务器端映射的字段相同；我们在配置时，对JFinal的模型忽略了key的大小（会默认全部设置成大写） -->
			<th field="ID" width="50">ID</th>
			<th field="KIND" width="50">Kind</th>
			<th field="NAME" width="50">Name</th>
			<th field="PRICE" width="50">Price</th>
			<th field="NUM" width="50">Number</th>
			<th field="SUMPRICE" width="50">SumPrice</th>
			<th field="REMARK" width="50">Remark</th>
		</tr>
	</thead>
</table>

<div id="toolbar">
	<a class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newUser()">New Goods</a>
	<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editUser()">Edit Goods</a>
	<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="removeUser()">Remove Goods</a>
	
	<div id="tb" style="padding:3px">
		<span>Kind:</span>
		<input id="searchkind" style="line-height:26px;border:1px solid #ccc">
		<span>Name:</span>
		<input id="searchname" style="line-height:26px;border:1px solid #ccc">
		<a class="easyui-linkbutton" plain="true" onclick="doSearch()">Search</a>
	</div>

</div>



<div id="dlg" class="easyui-dialog" style="width:400px;height:280px;padding:10px 20px"
			closed="true" buttons="#dlg-buttons">
		<div class="ftitle">Goods Information</div>
		<form id="fm" name="goodsfm" method="post" novalidate>
			<div class="fitem">
				<label>kind:</label>
				<!-- <input name="kind" class="easyui-validatebox" required="true"> -->
				<select name="kind" id="kinds">  <!--这里的name 和 field的名字匹配；选中后的值会自动赋值  -->
				</select>
			</div>
			<div class="fitem">
				<label>name:</label>
				<input name="name" class="easyui-validatebox" required="true">
			</div>
			<div class="fitem">
				<label>price:</label>
				<input name="price" class="easyui-numberbox" required="true">
			</div>
			<div class="fitem">
				<label>number:</label>
				<input name="num" class="easyui-numberbox"  required="true">
			</div>
			<div class="fitem">
				<input name="sumprice" type="hidden">
			</div>
			<div class="fitem">
				<label>remark:</label>
				<input name="remark" class="easyui-validatebox" >
			</div>
		</form>
	</div>
	<div id="dlg-buttons">
		<a class="easyui-linkbutton" iconCls="icon-ok" onclick="caculateSumPrice();saveUser()">Save</a>
		<a class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">Cancel</a>
	</div>
	
  </body>
</html>

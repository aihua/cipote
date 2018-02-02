<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<jsp:include page="header.jsp" />

<script>
var datatable;
	$(document).ready(function() {

		$('#exchange').select2({
		    ajax: {
		        type: 'get',
		        url: '/exchangeList',
		        dataType: 'json',
		        data: function (data) {
		            return {
		                json: data
		            };
		        },
		        processResults: function (data) {
		            return {
		                results: $.map(data, function(obj) {
		                	return { id: obj.id, text: obj.name };
		                })
		            };
		        }
		    }
		});
		
		$('#coin').select2({
		    ajax: {
		        type: 'get',
		        url: '/coinList',
		        dataType: 'json',
		        
		        data: function (term) {
		            return {
		                term: term
		            };
		        },
		        processResults: function (data, params) {
		            return {
		                results: $.map(data, function(obj) {
		                	return { id: obj.id, text: obj.formatedName };
		                })
		            };
		        }
		    }
		});
		
		$('#coinPair').select2({
		    ajax: {
		        type: 'get',
		        url: '/coinList',
		        dataType: 'json',
		        
		        data: function (term) {
		            return {
		                term: term
		            };
		        },
		        processResults: function (data, params) {
		            return {
		                results: $.map(data, function(obj) {
		                	return { id: obj.id, text: obj.formatedName };
		                })
		            };
		        }
		    }
		});
		
		
		datatable = $('#table_id').DataTable({
			"sAjaxSource": "/coinPerUserConfig/list",
			"sAjaxDataProp": "",
			"order": [[ 0, "asc" ]],
			"aoColumns": [
			    { "mData": "coinByExchange.coin.formatedName"},
			    { "mData": "coinByExchange.coinPair.formatedName"},
			    { "mData": "coinByExchange.exchange.name"},
		      	{ "mData": "invested" },
				{ "mData": "quantity" },
				{ "mData": "satoshiBuy" },
				{ "mData": "buyDate",
					"render": function (data) {
			        	var date = new Date(data);
			        	var month = date.getMonth() + 1;
			        	return date.getDate() + "/" + (month.length > 1 ? month : "0" + month) + "/" + date.getFullYear();
			    	} 
				},				
				{ "mData": "id",
					"render": function (data) {
			        	return '<a href="#" onclick="deleteCoin('+data+');">1<a/>';
			    	}
				},
			]
		});
		
		   $('button[type=submit]').click(function(e) {
			   
			      //Prevent default submission of form
			      e.preventDefault();
			      
			      //Remove all errors
			      $('input').next().remove();
			      
			      $.post({
			         url : 'coinPerUserConfig/add',
			         data : $('form[name=coinPerUserAdd]').serialize(),
			         success : function(res) {
			        	 datatable.ajax.reload();
			         
			            if(!res.validated){
			              //Set error messages
			              $.each(res.errorMessages,function(key,value){
			  	            $('input[name='+key+']').after('<span class="error">'+value+'</span>');
			              });
			            }
			         }
			      })
			   });
		   
		   $('#buyDate').datepicker({format: 'dd/mm/yyyy'});
		
	});
	
	function deleteCoin(coinPerUserID) {
		$.post( "coinPerUserConfig/removeValue", { coinPerUserID: coinPerUserID }, function( data ) {
			datatable.ajax.reload();
		});
		return false;
	}
</script>

	<div class="col-sm-12">
		<table id="table_id" class="display">
			<thead>
				<tr>
					<th>Nombre</th>
					<th>Pair</th>
					<th>Exchange</th>
					<th>Invertido</th>
					<th>Cantidad</th>
					<th>Satoshis Compra</th>
					<th>Fecha compra</th>
					<th>Eliminar</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th>Nombre</th>
					<th>Pair</th>
					<th>Exchange</th>
					<th>Invertido</th>
					<th>Cantidad</th>
					<th>Satoshis Compra</th>
					<th>Fecha compra</th>
					<th>Eliminar</th>
				</tr>
			</tfoot>
		</table>
	</div>
	<spring:hasBindErrors name="userForm">
		<c:forEach var="error" items="${errors.allErrors}">
			<b><spring:message message="${error}" /></b>
			<br />
		</c:forEach>
	</spring:hasBindErrors>
	<form:form method="POST" name="coinPerUserAdd" modelAttribute="registroEditado" action="/coinPerUserConfig/add">

		<fieldset class="form-group">
			<div class="form-check disabled">
				<div class="row">

					<div class="col-sm-2">
						Nombre cripto
						<form:select id="coin" class="form-control" path="coinByExchange.coin.id"></form:select>
					</div>
					<div class="col-sm-2">
						Nombre cripto Pair
						<form:select id="coinPair" class="form-control" path="coinByExchange.coinPair.id"></form:select>
					</div>
					<div class="col-sm-2">
						Nombre exchange
						<form:select id="exchange" class="form-control" path="coinByExchange.exchange.id"></form:select>
					</div>
					<div class="col-sm-1">
						Cantidad
						<form:input class="form-control" path="quantity" />
					</div>
					<div class="col-sm-1">
						Invertido
						<form:input class="form-control" path="invested" />
					</div>
					<div class="col-sm-1">
						Satoshis
						<form:input class="form-control" path="satoshiBuy" />
					</div>
					<div class="col-sm-1">
						Fecha de compra
						<form:input class="form-control" id="buyDate" path="buyDate" />
					</div>
				</div>
			</div>
		</fieldset>
		<button type="submit" class="btn btn-primary">Submit</button>
	</form:form>
<jsp:include page="footer.jsp" />

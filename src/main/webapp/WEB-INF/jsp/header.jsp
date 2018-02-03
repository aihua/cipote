<!DOCTYPE html>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<html lang="es">
<head>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/dt/jq-3.2.1/dt-1.10.16/r-2.2.1/datatables.min.css"/>
<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
<link href="../css/bootstrap-datepicker-1.7.0-dev/bootstrap-datepicker.css" rel="stylesheet" />

<script src="../js/jquery-3.2.1.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
<script src="https://cdn.datatables.net/v/dt/jq-3.2.1/dt-1.10.16/r-2.2.1/datatables.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
<script src="https://github.highcharts.com/highstock.src.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<script>
$(document).ready(function() {
	Highcharts.setOptions({
	    lang: {
	        months: [
	            'Enero', 'Febrero', 'Marzo', 'Abril',
	            'Mayo', 'Junio', 'Julio', 'Agosto',
	            'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
	        ],
	        weekdays: [
	            'Domingo', 'Lunes', 'Martes', 'Miercoles',
	            'Jueves', 'Viernes', 'Sabado'
	        ]
	    }
	});
});


</script>

<style>
.footer {
    position: fixed;
    left: 0;
    bottom: 0;
    width: 100%;
    color: white;
    text-align: center;
}

</style>

</head>
<body>
<nav class="navbar navbar-expand-sm bg-dark navbar-dark">
  <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
  <a class="navbar-brand " href="#">Navbar</a>
  <div class="collapse navbar-collapse" id="navbarNavDropdown">
    <ul class="navbar-nav">
      <li class="nav-item active">
        <a class="nav-link" href="/">Home <span class="sr-only">(current)</span></a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="/coinPerUserConfig">Configuración</a>
      </li>
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="http://example.com" id="navbarDropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          Dropdown link
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
          <a class="dropdown-item" href="#">Action</a>
          <a class="dropdown-item" href="#">Another action</a>
          <a class="dropdown-item" href="#">Something else here</a>
        </div>
      </li>
    </ul>
  </div>
</nav>
<div class="container-fluid mt-2">

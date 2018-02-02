<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<jsp:include page="header.jsp" />

<style>
#navbar {
    position: fixed;
    z-index:1;
    max-height: 90%;
    overflow-y: auto;
    max-width:100%;
}

@keyframes shadowPulse2 {
    0% {
        box-shadow: inset 0px 0px 10px 0px hsla(238, 65%, 50%, 1);
    }

    100% {
        box-shadow: inset 0px 0px 5px 0px hsla(0, 0%, 0%, 0);
    }
}

.shadow-pulse {
    animation-name: shadowPulse2;
    animation-duration: 1s;
    animation-iteration-count: 1;
    animation-timing-function: linear;
}
</style>
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
	
    $("#navbar div a").on('click', function(e) {

        // prevent default anchor click behavior
        e.preventDefault();
        
       	var id = this.toString().split("#").pop();
       	window.location.hash = this.hash;
       	
        $("#"+id).addClass('shadow-pulse');
       	$("#"+id).on('animationend', function(){     
       		$("#"+id).removeClass('shadow-pulse');
       	});
     });
	
    test();
});

function test () {
	
	// Create the chart
	Highcharts.chart('total', {
	    chart: {
	        type: 'pie'
	    },
	    title: {
	        text: 'Inversión total'
	    },
	    subtitle: {
	        text: ''
	    },
	    plotOptions: {
	        series: {
	            dataLabels: {
	                enabled: true,
	                format: '{point.name}: {point.y:.1f}€'
	            }
	        },
	        pie: {
	            allowPointSelect: true,
	            cursor: 'pointer',
	            dataLabels: {
	                enabled: false
	            },
	            showInLegend: true
	        }
	    },

	    tooltip: {
	        headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
	        pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.2f}%</b> of total<br/>'
	    },

	    series: [{
	        colorByPoint: true,
	        data: [
	        	<c:forEach items="${crypto}" varStatus="item">
	        	{
		            name: '${item.current.coinByExchange.coin.formatedName}',
		            y: ${item.current.invested},
		            id: ${item.current.coinByExchange.coin.id}
		        },
		        </c:forEach>
		        
		    ] 
	    }]
	});
    
    var messageList = $("#messages");
	<c:forEach items="${crypto}" varStatus="item">
	var chart${item.index} = createChart(${item.current.coinByExchange.coin.id}, ${item.current.coinByExchange.exchange.id}, "${item.current.coinByExchange.coin.formatedName}");
    </c:forEach>
}

function createChart(idCrypto, idExchange, name) {
    var groupingUnits = [
        [
            'minute', // unit name
        	[60] // allowed multiples
        ],
        [
            'day', [1]],
        [
            'week', [1]],
        [
            'month', [1]]
    ];
	
	
	 $.ajax({
		    url: '/getHistoricData?idCrypto='+idCrypto+'&idExchange='+idExchange,
		    type: 'GET',
		    async: true,
		    dataType: "json",
		    success: function (data) {
		    	var socket = new SockJS('/stomp');
		    	var stompClient = Stomp.over(socket);
		    	var processed_json = new Array(); 
		    	
		        for (i = 0; i < data.length; i++){
		        	processed_json.push([data[i].time, data[i].price]);
		        }
		        var options = {
		           chart: {
		           		renderTo: 'container'+idCrypto,
                   		rangeSelector: {
                       		inputDateFormat: '%d-%m-%Y %H:%M'
                   		},
                   type: 'line',
                   zoomType: 'x',
                   events: {
                	   selection: function(event) {
                		    console.log(
                		        Highcharts.dateFormat('%d-%m-%Y %H:%M:%S', event.xAxis[0].min),
                		        Highcharts.dateFormat('%d-%m-%Y %H:%M:%S', event.xAxis[0].max)
                		    );
                		}
                	}
               },
               legend: {
                   enabled: true,
                  /* labelFormatter: function() {
                       return this.name + '<br>' + 'Now: ' + '0.0' + ' €' + '<br>Max: ' + '0.0' + '<br>Min: ' + '0.0' + '<br>Avg: ' + '0.0';
                       }*/
               },
               title: {
                   text: name
               },
               xAxis: {
                   type: 'datetime',
                   title: {
                       text: 'Date'
                   },
                   minRange: 3600 * 1000
               },
               yAxis: {
                   title: {
                       text: 'EUR'
                   },
                   plotLines: [{
                       label: {
                           text: 'Baseline',
                           x: 25
                       },
                       color: 'orange',
                       width: 2,
                       value: 0,
                       dashStyle: 'longdashdot'
                   }],
               },
               rangeSelector: {
                   inputEnabled: false,
                   selected: 5,
                   buttons: [{
                       type: 'minute',
                       count: 60,
                       text: '1h'
                   }, {
                       type: 'day',
                       count: 1,
                       text: '1d'
                   }, {
                       type: 'week',
                       count: 1,
                       text: '1w'
                   }, {
                       type: 'month',
                       count: 1,
                       text: '1m'
                   }, {
                       type: 'year',
                       count: 1,
                       text: '1y'
                   }, {
                       type: 'all',
                       text: 'All'
                   }]
               },
               plotOptions: {
                   series: {
                       compare: 'datetime'
                   }
               },               
               series: [{
                   threshold: 0,
                   negativeColor: 'red',
                   color: 'green',
                   name: name,
                   data: processed_json,
                   pointStart: new Date().getTime()
               }]
	  };
		    	var chart = new Highcharts.StockChart(options);
		    	
		        stompClient.connect({ }, function(frame) {
		            stompClient.subscribe('/user/'+idCrypto+''+idExchange, function(data) {
		                var message = data.body;
		                
		                var obj = JSON.parse(message);
		                $("#stats"+idCrypto).empty();
		                if(parseFloat(obj.price).toFixed(2) < 0) {
		                	$("#stats"+idCrypto).append('<span class="text-danger">Balance: '+ parseFloat(obj.price).toFixed(2) + '€</span>');
		                } else {
		                	$("#stats"+idCrypto).append('<span class="text-success">Balance: '+ parseFloat(obj.price).toFixed(2) + '€</span>');
		                }
		                
		                chart.series[0].addPoint([obj.time, obj.price]);
		                chart.redraw();
		            });

		        });
		    }
	
	});
	 
}

</script>

<div class="row" style="margin-top:-8px">
	<div class="col-2 bg-dark">
			<nav class=" bg-dark nav navbar-dark navbar-expand-sm" id="navbar">
			  <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarNavDropdownLeft" aria-controls="navbarNavDropdownLeft" aria-expanded="false" aria-label="Toggle navigation">
			    <span class="navbar-toggler-icon"></span>
			  </button>
				<div class="flex-column mt-md-0 collapse navbar-collapse" style="align-items: initial;" id="navbarNavDropdownLeft">
					<c:forEach items="${crypto}" varStatus="item">
						<a class="nav-link text-secondary small" href="#container${item.current.coinByExchange.coin.id}">
							${item.current.coinByExchange.coin.formatedName}
							<div class="pl-3">
								<%-- <div class="text-primary">Invertido: ${item.current.invested}€</div>--%>
								<div class="text-info">Cantidad: ${item.current.quantity}</div>
								<div id="stats${item.current.coinByExchange.coin.id}"></div>
							</div>
						</a>
					</c:forEach>
				</div>
			</nav>
	</div>
	
	<div class="col-10">
		<div id="content" data-spy="scroll" data-target="#navbar">				
			<div class="row">
				<div id="total" class="col-sm-12"></div>
				<c:forEach items="${crypto}" varStatus="item">
					<div id="container${item.current.coinByExchange.coin.id}" class="pt-2 pl-2 pr-2 pb-2 col-sm-12"></div>
				</c:forEach>
			</div>
		</div>
	</div>
</div>

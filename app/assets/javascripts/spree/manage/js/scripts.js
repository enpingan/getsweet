/* UI */
$( window ).resize(function() {
    if ($(window).width() > 991 && $('.app_ui-wrapper .app_ui-block').hasClass('active')){
    	$('.app_ui-wrapper .app_ui-block').removeClass('active');
    	$('.app_ui-wrapper aside').removeClass('active-tablet');
    	if (!$('.app_ui-wrapper aside').hasClass('active-tablet')){
  			$('#accordion h3').removeClass('active');
  			$('#accordion div.accordion-block').hide(300);
  		}
    } else if($(window).width() > 767 && $(window).width() < 992){
    	$('.app_ui-wrapper aside').addClass('active');
    	$('.app_ui-wrapper .app_ui-block').addClass('active');
    	$('aside.active-tablet').removeClass('active-tablet');
      	if (!$('.app_ui-wrapper aside').hasClass('active-tablet')){
  			$('#accordion h3').removeClass('active');
  			$('#accordion div.accordion-block').hide(300);
		  }
    };
    if ($(window).width() > 767 ){
    	$('.app_ui-wrapper .shadow').hide();
    }
});
$(function() {
    if($(window).width() < 768 ){
   	    $('.app_ui-wrapper aside').removeClass('active');
    };
    $('.app_ui-wrapper .shadow').click(function(e){
   	   	$(".app_ui-wrapper header .nav-ico").trigger('click');
   	});
    if($(window).width() > 767 && $(window).width() < 992){
   	    $('#accordion h3').removeClass('ui-accordion-header-active ui-state-active ui-accordion-content-active');
   	    $('#accordion > div').hide();
   	    $('aside.active-tablet').removeClass('active-tablet');
    };
});
$( window ).resize(function() {
  $( "#log" ).append( "<div>Handler for .resize() called.</div>" );
});
$(".chart-block .tabs a").click(function(e){
	e.preventDefault();
	if(!$(this).hasClass('active')){
		$(this).addClass('active').siblings('a').removeClass('active');
		if($(this).hasClass('pie')){
			//$('.chart-block .chart div.pie').addClass('active').siblings('div').removeClass('active');
			$('.chart-block .chart div#pie').addClass('active');
			$('.chart-block .chart div#bar').removeClass('active');
		} else if($(this).hasClass('bar')){
			//$('.chart-block .chart div.bar').addClass('active').siblings('div').removeClass('active');
			$('.chart-block .chart div#pie').removeClass('active');
			$('.chart-block .chart div#bar').addClass('active');
		}
	};
});
$(".app_ui-wrapper header .nav-ico").click(function(){
	if($(window).width() > 767){
		$('.app_ui-wrapper aside').toggleClass('active-tablet');
		$('.app_ui-wrapper .app_ui-block').toggleClass('active');
		if(!$('.app_ui-wrapper aside').hasClass('active-tablet')){
			$('#accordion h3').removeClass('active');
			$('#accordion div.accordion-block').hide(300);
		}
	} else {
		$('.app_ui-wrapper aside').toggleClass('active');
		$('.app_ui-wrapper .app_ui-block').toggleClass('active');
	};
	if( $(window).width() < 768 && $('.app_ui-wrapper aside').hasClass('active')) {
	    $('.app_ui-wrapper .shadow').fadeIn(300);
	}
	else if($(window).width() < 768 && !$('.app_ui-wrapper aside').hasClass('active')) {
	    $('.app_ui-wrapper .shadow').fadeOut(300);
	} else {
		$('.app_ui-wrapper .shadow').hide();
	};
});
/* -- */
/* Accordion -*/
	$(function() {
	    $("#accordion h3").click(function(){
	    	if($(window).width() > 767){
	    		if(!$(this).hasClass('active') && $('aside.active').hasClass('active-tablet')){
		    		$(this).addClass('active').next('div.accordion-block').show(300);
		    		$(this).siblings('h3').removeClass('active').next('div.accordion-block').hide(300);
		    	} else if(!$('aside.active').hasClass('active-tablet')){
	    			$(".app_ui-wrapper header .nav-ico").trigger('click');
		    	} else if($(this).hasClass('active')){
		    		$(this).removeClass('active').next('div.accordion-block').hide(300);
		    	};
	    	} else {
	    		if(!$(this).hasClass('active')){
		    		$(this).addClass('active').next('div.accordion-block').show(300);
		    		$(this).siblings('h3').removeClass('active').next('div.accordion-block').hide(300);
		    	} else {
		    		$(this).removeClass('active').next('div.accordion-block').hide(300);
		    	}
	    	}
		});
	});
 /* -- */

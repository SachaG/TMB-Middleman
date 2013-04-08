$(function(){
	$('body').addClass('animate');
	$('#origin').val(document.referrer);
	$('#landing').val(document.title);
	$('.pullcenter img').click(function(){
		var $this=$(this);
		$('#lightbox').removeClass('hide').find('img').attr('src', $this.attr('src'));
	});
	$('#lightbox').click(function(){
		$(this).addClass('hide');
	})
});
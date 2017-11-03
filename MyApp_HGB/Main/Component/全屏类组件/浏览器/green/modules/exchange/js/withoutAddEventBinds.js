$(document).on("pageInit", "#page-withoutAdd_tpl", function() {
	$(".div-custom-cardBoxs .span-custom-righttext").on("click", function(e) {
		$.router.load('./selectMerchant_tpl.html',true);
	});

});

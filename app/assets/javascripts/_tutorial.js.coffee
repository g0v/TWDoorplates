$(document).ready ->
	$("#tutorial-slideshow").bjqs({
		width: 1202,
		height: 746,
		responsive: true,
		automatic: false
	})
	$("#tutorial-button").click( ->
		$.blockUI {
			message: $("#tutorial-slideshow")
			onOverlayClick: $.unblockUI
			css: {
				width: '65%'
				top: '10%'
				left: '17.5%',
			}
		}
		return false
	)
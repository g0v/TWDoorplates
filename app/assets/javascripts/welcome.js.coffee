# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$("#city-code-selector button").click ->
	$this = $(this)
	$("#doorplate-search-form input[name=cityCode]").val($this.val())
	$("#city-code-selector button").removeClass("active")
	$this.addClass("active")

$("#area-code-selector button").click ->
	$this = $(this)
	$("#doorplate-search-form input[name=areaCode]").val($this.val())
	$("#area-code-selector button").removeClass("active")
	$this.addClass("active")
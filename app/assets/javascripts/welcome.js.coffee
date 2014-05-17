# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$("#city-code-selector").on "click", "button", ->
	$this = $(this)
	buildAreaButtons($this.val())
	$("#doorplate-search-form input[name=cityCode]").val($this.val())
	$("#city-code-selector button").removeClass("active")
	$this.addClass("active")

$("#area-code-selector").on "click", "button", ->
	$this = $(this)
	$("#doorplate-search-form input[name=areaCode]").val($this.val())
	$("#area-code-selector button.active").removeClass("active")
	$this.addClass("active")

buildAreaButtons = (cityCode) ->
	$("#area-code-selector").empty()
	$("#area-code-selector").append("<button type=\"button\" class=\"btn btn-default active\" value=\"\">不拘</button>")
	areaCode = $.map($(document).attr("cityAreaCodes"), (val) ->
	    val.areas if val.cityCode == cityCode
	)
	$(areaCode).each ->
		node = $("<button type=\"button\" class=\"btn btn-default\"></button>")
		node.val($(this)[0].areaCode)
		node.text($(this)[0].areaName)
		$("#area-code-selector").append(node)

$.ajax {
	url: "/assets/cityAreaCodes.json",
	type: "GET",
	dataType: "json"
	success: (data)->
		$(document).attr("cityAreaCodes", data)
		buildAreaButtons(data[0].cityCode)
		$("#city-code-selector button")[0].click()
	,
	error: ->
		alert("Error loading area codes")
}